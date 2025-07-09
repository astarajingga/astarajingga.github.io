---
title: "Membuat Device IoT: Monitoring Tempat Sampah Berbasis ESP8266 dan ThingsBoard untuk Smart City"
date: 2025-05-30
categories: [IoT, Tutorial, microcontroller]
math: true
tags: [ESP8266, ESP32, Arduino, IoT, Sensor]
image:
  path: /assets/img/smartgarbage.png
  alt: "Monitoring Tempat Sampah dengan IoT dan ThingsBoard"
---

> 📡 Panduan langkah demi langkah membuat sistem IoT untuk pemantauan tempat sampah real-time menggunakan ESP8266 dan ThingsBoard.

---

## 🎯 1. Tujuan
Judul ini diangkat sebagai respons terhadap masih rendahnya perhatian terhadap pengelolaan dan manajemen limbah di wilayah perkotaan, yang berakibat pada berbagai permasalahan lingkungan salah satunya adalah bencana alam banjir yang sangat mengganggu, karena saya dan rekan saya yang notabennya salah satu korban hehe. Oleh karena itu, saya dan rekan saya (pascal) merancang alat/sistem ini untuk sedikit mengurangi dampak tersebut. tidak hanya itu, alat ini dirancang sekaligus untuk memenuhi tugas besar pada salah satu mata kuliah kami, perangkat ini dirancang sebagai solusi berbasis teknologi untuk mendukung sistem Monitoring Tempat Sampah dengan memanfaatkan mikrokontroler unit [ESP8266] yang sering digunakan oleh para pengembang karena fleksible. Alat ini bertujuan untuk memenuhi kebutuhan pemantauan secara real-time melalui integrasi dengan platform Internet of Things (IoT) seperti [ThingsBoard], namun bukan hanya Thingsboard saja, alat yang kami buat dapat diaplikasikan ke berbagai platform IoT lain sperti [ThingSpeak, Blynk, MQTT, maupun Web API dan sejenisnya].

pada dasarnya kami memilih [ThingsBoard](https://thingsboard.io) karena mudah digunakan, gratis (open-source), dukungan MQTT yang solid, serta tampilan `widget` yang ditawarkan cukup menarik dan cocok untuk diaplikasikan pada project yang kami buat.

## 🧰 2. Alat dan Bahan

| Komponen                      | jumlah           | Fungsi                            |
| :---------------------------- | :----------------| --------------------------------- |
| ESP8266 AMICA                 |         1        | mikrokontroller                   |
| GPS NEO 6M                    |         1        | Posisioning                       |
| ULTRASONIK HC-SR04            |         1        | Mengukur tingkat kepenuhan sampah |
| SENSOR GAS MQ2                |         1        | mengukur tingkat kontaminan gas   |

> 💡 *Komponen dapat disesuaikan sesuai kebutuhan lapangan. Kami terbuka terhadap saran dan modifikasi.*

## 🧠 3. Konsep Dasar Sistem
Sistem yang dikembangkan merupakan solusi Internet of Things (IoT) untuk pemantauan tempat sampah cerdas yang berfungsi secara real-time. Perangkat utama terdiri dari mikrokontroler ESP8266, dilengkapi dengan sejumlah sensor dan modul komunikasi untuk mengukur dan mengirimkan data ke platform ThingsBoard melalui protokol MQTT.

### 🗂️ 3.1 Arsitektur Sistem
- **IoT (Internet of Things)**: Jaringan perangkat fisik yang saling terhubung dan dapat bertukar data.
- **Sensor**: Mengukur variabel lingkungan (jarak, gas, lokasi).
- **Platform Cloud (ThingsBoard)**: Menyimpan, menampilkan, dan mengelola data sensor secara real-time.

### 📦 3.2 Komponen dan Fungsinya

#### 🔌 3.2.1 ESP8266 Amica
ESP8266 berperan sebagai pusat kendali yang mengintegrasikan seluruh komponen sensor dan komunikasi. Mikrokontroler ini memiliki konektivitas WiFi bawaan, serta mampu menjalankan komunikasi MQTT dengan ThingsBoard Cloud.

#### 📏 3.2.2 Sensor Ultrasonik HC-SR04
Sensor ini digunakan untuk mengukur jarak antara penutup tempat sampah dan permukaan sampah. Jarak yang diperoleh kemudian digunakan untuk menghitung tingkat kepenuhan (dalam persentase) berdasarkan rumus:

$$
\text{Kepenuhan}(\%) = \left( \frac{H - d}{H} \right) \times 100
$$

Dengan:
- \( H \) = tinggi maksimal tong (100 cm),
- \( d \) = jarak dari sensor ke permukaan sampah.

📌 *Contoh perhitungan:*  
Jika \( d = 30 \), maka:

$$
\text{Kepenuhan} = \left( \frac{100 - 30}{100} \right) \times 100 = 70\%
$$

anda dapat menyeseuaikan sendiri kode dengan ketinggian tempat sampah yang anda miliki, anda hanya perlu mengubah baris kode dibahwah:

``` c++
float max_tong_cm = 100.0; // ubah sesuai dengan ketinggian tempat sampah anda, jika 50 cm, tuliskan "50.0"
```

#### 🌫 3.2.3 Sensor Gas MQ-2
Sensor MQ-2 mampu mendeteksi gas seperti LPG, asap, alkohol, dan karbon monoksida. Nilai analog dari sensor digunakan sebagai indikator tingkat pencemaran udara di sekitar tempat sampah.

#### 🛰 3.2.4 GPS NEO-6M (TinyGPS++)
Modul GPS digunakan untuk mendapatkan data posisi geografis dari perangkat. Data latitude dan longitude dikodekan melalui pustaka `TinyGPSPlus` untuk kemudian dikirimkan ke server ThingsBoard.

#### 📡 3.2.5 MQTT dan ThingsBoard
ESP8266 menggunakan protokol MQTT untuk mengirim data dalam format JSON:
```json
{
  "latitude": -6.123456,
  "longitude": 106.123456,
  "kepenuhan": 82.5,
  "gas": 456
}
```

## 💻 4. Alur Kerja Sistem

1. ESP8266 terhubung ke jaringan WiFi.
2. Membaca data dari sensor:
   - 🔊 **Ultrasonik (HC-SR04)** → mengukur jarak → dihitung tingkat kepenuhan,
   - 🌫 **MQ2** → membaca tingkat kontaminasi gas,
   - 🛰 **GPS NEO-6M** → mengambil koordinat lokasi.
3. Data diolah dan dikemas dalam format **JSON**.
4. Dikirim secara berkala setiap **2 detik** ke **ThingsBoard Cloud** via protokol **MQTT**.
5. Data ditampilkan dalam bentuk:
   - 📈 Grafik,
   - 📋 Tabel,
   - 🗺 Peta Lokasi.

---

## 🔧 5. Skematik Rangkaian

![Desktop View](/assets/img/smartgarbage.png)

---

## 🌍 6. Tampilan Dashboard ThingsBoard

![Desktop View](/assets/img/thingsboard.png)

---

## 🔣 7. Source Code Arduino

kode lengkap:

```c++
// === Library yang digunakan ===
#include <SoftwareSerial.h>
#include <TinyGPS++.h>
#include <ESP8266WiFi.h>
#include <PubSubClient.h>

// === Konfigurasi GPS ===
static const int RXPin = D7;
static const int TXPin = D8;
static const uint32_t GPSBaud = 9600;
TinyGPSPlus gps;
SoftwareSerial ss(RXPin, TXPin);

// === WiFi & MQTT Configuration ===
const char* ssid = "";       // Ganti dengan SSID WiFi kamu
const char* password = "";   // Ganti dengan password WiFi kamu
const char* mqtt_server = "thingsboard.cloud";
const int mqtt_port = 1883;
const char* token = "";      // Ganti dengan access token dari ThingsBoard

WiFiClient espClient;
PubSubClient client(espClient);

// === Konfigurasi Sensor ===
#define TRIG_PIN D5
#define ECHO_PIN D6
#define MQ2_PIN A0
float max_tong_cm = 100.0;

// === Waktu Interval Kirim Data ===
unsigned long lastSendTime = 0;
const unsigned long interval = 2000;  // Kirim setiap 2 detik

// === Setup WiFi ===
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

// === Reconnect MQTT ===
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

// === Fungsi Sensor Jarak ===
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

// === Fungsi Sensor Gas ===
int readGasLevel() {
  return analogRead(MQ2_PIN);
}

// === Setup Awal ===
void setup() {
  Serial.begin(115200);
  ss.begin(GPSBaud);

  pinMode(TRIG_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);
  pinMode(MQ2_PIN, INPUT);

  setup_wifi();
  client.setServer(mqtt_server, mqtt_port);
}

// === Loop Utama ===
void loop() {
  if (!client.connected()) reconnect();
  client.loop();

  while (ss.available() > 0) gps.encode(ss.read());

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

## 📌 8. Penutup
Proyek ini merupakan langkah awal kami untuk membangun sistem Smart Waste Management berbasis teknologi. Diharapkan alat ini bisa dikembangkan lebih lanjut agar bisa terintegrasi dengan sistem kota cerdas (smart city).
> 🙌 Jika kamu tertarik mencoba atau mengembangkan, jangan ragu untuk menghubungi kami atau tinggalkan komentar!

