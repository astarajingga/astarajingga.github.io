---
title: "Membuat Custom Small Display Mini Weather Stations Dengan Koneksi API"
date: 2025-07-07 12:30:00 +0800
categories: [IoT, Tutorial, microcontroller, Weather Station]
math: true
tags: [ESP8266, ESP32, Arduino, IoT, Sensor]
image:
  path: https://ae01.alicdn.com/kf/S00133e0086da42e6860100709f0e202aP.jpg
  alt: "Monitoring Tempat Sampah dengan IoT dan ThingsBoard"
---

# 📘 Tutorial: Membuat Custom Small Display Mini Weather Station dengan Koneksi API menggunakan Wemos D1 Mini dan Layar TFT ST7789

---

## 📌 1. Tujuan

Membuat perangkat stasiun cuaca mini yang menampilkan informasi cuaca real-time (suhu, kondisi cuaca, kelembaban) pada layar TFT ST7789, dengan data dari API *OpenWeatherMap*, menggunakan koneksi WiFi dari **Wemos D1 Mini (ESP8266)**.

---

## 🧰 2. Alat dan Bahan

| Komponen                    | Jumlah | Keterangan                          |
|-----------------------------|--------|--------------------------------------|
| Wemos D1 Mini (ESP8266)     | 1      | Mikrokontroler dengan WiFi           |
| Layar TFT ST7789 (240x240)  | 1      | Layar tampilan 1.3" atau 1.54"       |
| Kabel Jumper                | Beberapa | Untuk koneksi antar komponen       |
| Breadboard                  | 1      | Opsional, untuk perakitan awal      |
| Akses Internet + API Key    | 1      | Dari https://openweathermap.org     |
| Daya USB / Powerbank        | 1      | Untuk memberi daya perangkat        |

---

## 📚 3. Teori Singkat

- **Wemos D1 Mini** adalah board ESP8266 kecil dengan kemampuan WiFi, cocok untuk proyek IoT.
- **ST7789** adalah modul layar TFT SPI dengan resolusi 240x240 piksel.
- **OpenWeatherMap API** menyediakan data cuaca gratis dengan format JSON.
- Gambar ikon cuaca dapat ditampilkan pada layar berdasarkan kondisi seperti `clear`, `clouds`, `rain`, dll.

---

## ⚙️ 4. Langkah-Langkah Pembuatan

### 🔧 4.1 Koneksi Perangkat Keras

| ST7789 Pin | Wemos D1 Mini | Keterangan   |
|------------|---------------|--------------|
| VCC        | 3V3           | Power        |
| GND        | GND           | Ground       |
| SCL (CLK)  | D5 (GPIO14)   | SPI Clock    |
| SDA (MOSI) | D7 (GPIO13)   | SPI Data     |
| RES (RST)  | D4 (GPIO2)    | Reset        |
| DC         | D3 (GPIO0)    | Data/Command |
| CS         | GND           | Bisa di-GND-kan bila tidak digunakan |

> ⚠️ Pastikan layar Anda 3.3V (bukan 5V), agar tidak rusak!

---

### 💻 4.2 Instalasi Library

Pastikan kamu telah menginstal di Arduino IDE:

- **Board**: ESP8266 by ESP8266 Community
  - URL Board Manager: `http://arduino.esp8266.com/stable/package_esp8266com_index.json`
- **Library yang dibutuhkan**:
  - `Adafruit ST7789`
  - `Adafruit GFX`
  - `ESP8266WiFi`
  - `ArduinoJson`
  - `ESP8266HTTPClient`
  - (Opsional) `TJpg_Decoder` untuk menampilkan gambar `.jpg`

---

### ✏️ 4.3 Contoh Kode Program

```c++
#include <ESP8266WiFi.h>
#include <Adafruit_GFX.h>
#include <Adafruit_ST7789.h>
#include <ArduinoJson.h>
#include <SPI.h>
#include <ESP8266HTTPClient.h>

#define TFT_CS    -1
#define TFT_RST   D4
#define TFT_DC    D3

Adafruit_ST7789 tft = Adafruit_ST7789(TFT_CS, TFT_DC, TFT_RST);

const char* ssid = "NAMA_WIFI";
const char* password = "PASSWORD_WIFI";
const String apiKey = "API_KEY_OPENWEATHERMAP";
const String city = "Bandung";
const String countryCode = "ID";

void setup() {
  Serial.begin(115200);
  tft.init(240, 240);
  tft.setRotation(2);
  tft.fillScreen(ST77XX_BLACK);
  tft.setTextColor(ST77XX_WHITE);
  tft.setTextWrap(true);

  WiFi.begin(ssid, password);
  tft.println("Connecting to WiFi...");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    tft.print(".");
  }

  tft.println("WiFi connected.");
}

void loop() {
  if(WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    String endpoint = "http://api.openweathermap.org/data/2.5/weather?q=" + city + "," + countryCode + "&appid=" + apiKey + "&units=metric";
    
    http.begin(endpoint);
    int httpCode = http.GET();

    if (httpCode == 200) {
      String payload = http.getString();
      StaticJsonDocument<1024> doc;
      deserializeJson(doc, payload);

      String weather = doc["weather"][0]["main"];
      float temp = doc["main"]["temp"];
      int humidity = doc["main"]["humidity"];

      tft.fillScreen(ST77XX_BLACK);
      tft.setCursor(0, 0);
      tft.setTextSize(2);
      tft.print("Kota: "); tft.println(city);
      tft.print("Cuaca: "); tft.println(weather);
      tft.print("Suhu: "); tft.print(temp); tft.println(" C");
      tft.print("Lembab: "); tft.print(humidity); tft.println(" %");
    } else {
      tft.println("Gagal mengambil data");
    }

    http.end();
  }

  delay(60000); // Update tiap 60 detik
}
```