---
title: "Membuat Device IoT: [Pengembangan alat Monitoring Tempat Sampah menggunakan Platform Thingsboard untuk mendukung Smart City]"
date: 2025-05-30
categories: [IoT, Tutorial]
math: true
tags: [ESP8266, ESP32, Arduino, IoT, Sensor]
author: astarajingga
image:
  path: /assets/img/smartgarbage.png
  alt: "[Pengembangan alat Monitoring Tempat Sampah menggunakan Platform Thingsboard untuk mendukung Smart City]"
---

> Panduan langkah demi langkah membuat device IoT menggunakan [ESP8266/ESP32] untuk 

## 1. Tujuan

Judul ini diangkat sebagai respons terhadap masih rendahnya perhatian terhadap pengelolaan dan manajemen limbah di wilayah perkotaan, yang berakibat pada berbagai permasalahan lingkungan salah satunya adalah bencana alam banjir yang sangat mengganggu, karena saya dan rekan saya salah satu korban hehe. Oleh karena itu, saya dan rekan saya (pascal) merancang alat/sistem ini untuk sedikit mengurangi dampak tersebut. tidak hanya itu, alat ini dirancang sekaligus untuk memenuhi tugas besar pada salah satu mata kuliah kami, perangkat ini dirancang sebagai solusi berbasis teknologi untuk mendukung sistem Monitoring Tempat Sampah dengan memanfaatkan mikrokontroler [ESP8266]. Alat ini bertujuan untuk memenuhi kebutuhan pemantauan secara real-time melalui integrasi dengan platform Internet of Things (IoT) seperti [ThingsBoard], namun bukan hanya Thingsboard saja, alat yang kami buat dapat diaplikasikan ke berbagai platform IoT lain sperti [ThingSpeak, Blynk, MQTT, maupun Web API].

pada dasarnya kami memilih thingsboard karena mudah digunakan dan gratis, serta tampilan `widget` yang ditawarkan cukup menarik dan cocok untuk diaplikasikan pada project yang kami buat.

---

## 2. Alat dan Bahan
adapun alat dan bahan yang digunakan untuk simulasi awal adalah :

| No | Komponen            | Jumlah | Keterangan             |
|----|---------------------|--------|------------------------|
| 1  | ESP8266             | 1      | Microcontroller utama  |
| 2  | GPS Neo 6M          | 1      | Untuk mengetahui posisi tempat sampah     |
| 3  | Breadboard + Kabel  | 1 set  | Untuk perakitan awal   |
| 4  | Sensor gas MQ2      | 1      | untuk mengukur kontaminan gas dalam tempat sampah|
| 5  | `Modul WiFi/GSM`    | 1      | `opsional Jika diperlukan`        |
| 6  | Sensor Ultrasonik HC SR-04    | -      | untuk mengukur kapasitas sampah        |
| 7  | PowerBank 5V     | -      | Sebagai daya utama untuk esp8266      |
---

urgensi pada komponen yang kami gunakan diatas merupakan tahap pengembangan. oleh karena itu kami dengan senang hati dan terbuka menerima segala masukkan jika ada urgensi khusus pada salah satu komponen yang menurut pembaca baik untuk diaplikasikan pada project ini.

## 3. Konsep Dasar

Sistem yang dikembangkan merupakan solusi Internet of Things (IoT) untuk pemantauan tempat sampah cerdas yang berfungsi secara real-time. Perangkat utama terdiri dari mikrokontroler ESP8266, dilengkapi dengan sejumlah sensor dan modul komunikasi untuk mengukur dan mengirimkan data ke platform ThingsBoard melalui protokol MQTT.

### 3.1 Arsitektur Sistem

- **IoT (Internet of Things)**: Jaringan perangkat fisik yang terhubung ke internet.
- **Sensor**: Mengambil data fisik dari lingkungan.
- **Cloud Platform**: Menyimpan dan menganalisis data sensor.

---
Data yang dikumpulkan berupa:
- Lokasi geografis (latitude, longitude),
- Tingkat kepenuhan tempat sampah,
- Kadar gas di lingkungan sekitar.

### 3.2 Komponen dan Fungsinya

#### 3.2.1 Mikrokontroler ESP8266
ESP8266 berperan sebagai pusat kendali yang mengintegrasikan seluruh komponen sensor dan komunikasi. Mikrokontroler ini memiliki konektivitas WiFi bawaan, serta mampu menjalankan komunikasi MQTT dengan ThingsBoard Cloud.

#### 3.2.2 Sensor Ultrasonik HC-SR04
Sensor ini digunakan untuk mengukur jarak antara penutup tempat sampah dan permukaan sampah. Jarak yang diperoleh kemudian digunakan untuk menghitung tingkat kepenuhan (dalam persentase) berdasarkan rumus:

```math
\text{Kepenuhan}(\%) = \left( \frac{H - d}{H} \right) \times 100
```

Dengan:
- H = tinggi maksimum tempat sampah (100 cm),
- 𝑑
d = jarak aktual dari sensor ke permukaan sampah.

#### 3.2.3 Sensor Gas MQ-2
Sensor MQ-2 mampu mendeteksi gas seperti LPG, asap, alkohol, dan karbon monoksida. Nilai analog dari sensor digunakan sebagai indikator tingkat pencemaran udara di sekitar tempat sampah.

#### 3.2.4 Modul GPS (TinyGPS++)
Modul GPS digunakan untuk mendapatkan data posisi geografis dari perangkat. Data latitude dan longitude dikodekan melalui pustaka `TinyGPSPlus` untuk kemudian dikirimkan ke server ThingsBoard.

#### 3.2.4 Protokol MQTT dan ThingsBoard
ESP8266 mengirimkan data melalui protokol MQTT ke platform ThingsBoard Cloud, menggunakan token otentikasi khusus. Payload data dikirim dalam format JSON, dan dapat divisualisasikan dalam bentuk grafik, tabel, maupun peta lokasi.

berikut merupakan contoh output/payloud yang akan muncul pada serial monitor ketika kode di upload pada ESP8266:
```json
{
  "latitude": -6.123456,
  "longitude": 106.123456,
  "kepenuhan": 82.5,
  "gas": 456
}
```
berikut saya sertakan kode programnya secara lengkap:

```arduino
#include <SoftwareSerial.h>
#include <TinyGPS++.h>
#include <ESP8266WiFi.h>
#include <PubSubClient.h>

// ===== konfigurasi untuk GPS =====
static const int RXPin = D7;
static const int TXPin = D8;
static const uint32_t GPSBaud = 9600;
TinyGPSPlus gps;
SoftwareSerial ss(RXPin, TXPin);

// ===== konfigurasi WIFI =====
const char* ssid = ""; // gunakan ssid wifi anda
const char* password = ""; // gunakan password wifi anda

// ===== MQTT ThingsBoard =====
const char* mqtt_server = "thingsboard.cloud";
const int mqtt_port = 1883;
const char* token = ""; // gunakan akses token yang telah anda buat di thingsboard

WiFiClient espClient;
PubSubClient client(espClient);

// ===== konfigurasi sensor =====
#define TRIG_PIN D5
#define ECHO_PIN D6
#define MQ2_PIN A0
float max_tong_cm = 100.0;

// ===== Waktu upload data ke thingsboard =====
unsigned long lastSendTime = 0;
const unsigned long interval = 2000;  // 2 detik merupakan interval waktu yang saya gunakan agar perubahan data lebih cepat tetapi tentu saja akan memakan lebih banyak bandwidth internet anda.

// ===== koneksi WIFI =====
void setup_wifi() {
  delay(10);
  Serial.print("Connecting to WiFi");
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nWiFi connected");
}

// ===== MQTT =====
void reconnect() {
  while (!client.connected()) {
    Serial.print("Connecting to ThingsBoard...");
    if (client.connect("ESP8266Client", token, NULL)) {
      Serial.println(" connected");
    } else {
      Serial.print(" failed, rc=");
      Serial.print(client.state());
      Serial.println(" retrying in 5 seconds");
      delay(5000);
    }
  }
}

// ===== fungsi sensor =====
float getDistanceCM() {
  digitalWrite(TRIG_PIN, LOW);
  delayMicroseconds(2);
  digitalWrite(TRIG_PIN, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG_PIN, LOW);

  long duration = pulseIn(ECHO_PIN, HIGH, 30000);
  float distance_cm = duration * 0.034 / 2;
  if (distance_cm <= 0 || distance_cm > max_tong_cm) return max_tong_cm;
  return distance_cm;
}

int readGasLevel() {
  return analogRead(MQ2_PIN);
}

// ===== Setup =====
void setup() {
  Serial.begin(115200);
  ss.begin(GPSBaud);

  pinMode(TRIG_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);
  pinMode(MQ2_PIN, INPUT);

  setup_wifi();
  client.setServer(mqtt_server, mqtt_port);
}

// ===== Loop =====
void loop() {
  if (!client.connected()) reconnect();
  client.loop();

  // Update data GPS
  while (ss.available() > 0) gps.encode(ss.read());

  // Kirim data setiap interval
  if (millis() - lastSendTime >= interval && gps.location.isValid()) {
    lastSendTime = millis();

    float latitude = gps.location.lat();
    float longitude = gps.location.lng();
    float jarak = getDistanceCM();
    float kepenuhan_cm = max_tong_cm - jarak;
    float kepenuhan_persen = (kepenuhan_cm / max_tong_cm) * 100.0;
    int gasLevel = readGasLevel();

    Serial.println("==== Data Dikirim ====");
    Serial.print("Latitude   : "); Serial.println(latitude, 6);
    Serial.print("Longitude  : "); Serial.println(longitude, 6);
    Serial.print("Jarak      : "); Serial.println(jarak, 2);
    Serial.print("Kepenuhan  : "); Serial.print(kepenuhan_persen, 1); Serial.println(" %");
    Serial.print("Gas Level  : "); Serial.println(gasLevel);

    String payload = "{";
    payload += "\"latitude\":" + String(latitude, 6) + ",";
    payload += "\"longitude\":" + String(longitude, 6) + ",";
    payload += "\"kepenuhan\":" + String(kepenuhan_persen, 1) + ",";
    payload += "\"gas\":" + String(gasLevel);
    payload += "}";

    client.publish("v1/devices/me/telemetry", payload.c_str());
    Serial.println("Data sent to ThingsBoard Cloud.");
    Serial.println("======================");
  }
}
```

## 4. Alur kerja sistem
Berikut adalah tahapan alur kerja sistem:

ESP8266 melakukan inisialisasi koneksi ke jaringan WiFi dan menghubungkan dirinya ke server MQTT ThingsBoard. Setelah koneksi berhasil, sistem mulai membaca data dari beberapa sensor, yaitu sensor ultrasonik HC-SR04 untuk mengukur jarak antara tutup tong dan permukaan sampah sebagai indikator tingkat kepenuhan, sensor MQ-2 untuk mendeteksi konsentrasi gas sebagai indikator adanya potensi kontaminan, serta modul GPS untuk memperoleh informasi lokasi perangkat. Data dari ketiga komponen ini kemudian diolah dan dikemas dalam format JSON. Payload JSON ini dikirim secara berkala setiap 2 detik ke platform ThingsBoard melalui protokol MQTT. Selanjutnya, data ditampilkan dalam bentuk visual melalui antarmuka ThingsBoard, memungkinkan pengguna untuk memantau status tempat sampah secara langsung dan real-time.

## 5. Rangkaian dan Skematik

![Desktop View](/assets/img/smartgarbage.png)

## 6. Tampilan Thingsboard

![Desktop View](/assets/img/thingsboard.png)


nanti disambung