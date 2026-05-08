#include <WiFi.h>
#include <HTTPClient.h>
#include <SPI.h>
#include <MFRC522.h>
#include <ArduinoJson.h>

#define WIFI_SSID "SLT-Fiber-BHPf8-2.4G_EXT"
#define WIFI_PASSWORD "Bluetex@5724"

#define VERIFY_URL "http://192.168.1.185:3000/verify-rfid"
#define LOG_URL "http://192.168.1.185:3000/machine-done"

#define ESP_ID "ESP32_1"

// RFID pins
#define RFID1_SS 5
#define RFID2_SS 25
#define RST_PIN 22

// Outputs
#define GREEN_LED 12
#define BUZZER 13

MFRC522 rfid1(RFID1_SS, RST_PIN);
MFRC522 rfid2(RFID2_SS, RST_PIN);

// Buttons
int startButtons[2] = {14, 26};
int endButtons[2]   = {15, 27};

bool startState[2] = {HIGH, HIGH};
bool endState[2]   = {HIGH, HIGH};

bool verified[2] = {false, false};
int employeeId[2] = {0, 0};
String currentUID[2] = {"", ""};

void beep() {
  digitalWrite(BUZZER, HIGH);
  delay(150);
  digitalWrite(BUZZER, LOW);
}

String readUID(MFRC522 &reader) {
  String uid = "";
  for (byte i = 0; i < reader.uid.size; i++) {
    uid += String(reader.uid.uidByte[i], HEX);
    if (i < reader.uid.size - 1) uid += " ";
  }
  uid.toUpperCase();
  return uid;
}

void verifyRFID(String uid, int machineIndex) {
  HTTPClient http;
  http.begin(VERIFY_URL);
  http.addHeader("Content-Type", "application/json");

  String body = "{\"rfid_uid\":\"" + uid + "\"}";
  int res = http.POST(body);
  String payload = http.getString();

  Serial.println("RFID UID: " + uid);
  Serial.println(payload);

  if (res == 200) {
    DynamicJsonDocument doc(512);
    deserializeJson(doc, payload);

    if (doc["success"] == true) {
      verified[machineIndex] = true;
      employeeId[machineIndex] = doc["employee_id"];
      currentUID[machineIndex] = uid;

      digitalWrite(GREEN_LED, HIGH);
      beep();

      Serial.print("Machine ");
      Serial.print(machineIndex + 1);
      Serial.println(" employee verified");
    } else {
      verified[machineIndex] = false;
      Serial.println("Invalid RFID");
    }
  }

  http.end();
}

void sendLog(int machineIndex, String action) {
  if (!verified[machineIndex]) {
    Serial.println("Scan RFID first!");
    return;
  }

  int machineNo = machineIndex + 1;

  HTTPClient http;
  http.begin(LOG_URL);
  http.addHeader("Content-Type", "application/json");

  String json = "{";
  json += "\"esp_id\":\"" + String(ESP_ID) + "\",";
  json += "\"employee_id\":" + String(employeeId[machineIndex]) + ",";
  json += "\"rfid_uid\":\"" + currentUID[machineIndex] + "\",";
  json += "\"machine\":" + String(machineNo) + ",";
  json += "\"action\":\"" + action + "\"";
  json += "}";

  int res = http.POST(json);

  Serial.println(json);
  Serial.print("Response: ");
  Serial.println(res);

  http.end();

  if (res > 0) {
    beep();

    verified[machineIndex] = false;
    employeeId[machineIndex] = 0;
    currentUID[machineIndex] = "";

    digitalWrite(GREEN_LED, LOW);

    Serial.println("Log saved. Scan again.");
  }
}

void setup() {
  Serial.begin(115200);

  pinMode(GREEN_LED, OUTPUT);
  pinMode(BUZZER, OUTPUT);

  digitalWrite(GREEN_LED, LOW);
  digitalWrite(BUZZER, LOW);

  for (int i = 0; i < 2; i++) {
    pinMode(startButtons[i], INPUT_PULLUP);
    pinMode(endButtons[i], INPUT_PULLUP);
  }

  SPI.begin(18, 19, 23);

  rfid1.PCD_Init();
  rfid2.PCD_Init();

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting WiFi");

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("\nReady - scan RFID");
}

void loop() {
  if (rfid1.PICC_IsNewCardPresent() && rfid1.PICC_ReadCardSerial()) {
    String uid = readUID(rfid1);
    verifyRFID(uid, 0);
    rfid1.PICC_HaltA();
    delay(500);
  }

  if (rfid2.PICC_IsNewCardPresent() && rfid2.PICC_ReadCardSerial()) {
    String uid = readUID(rfid2);
    verifyRFID(uid, 1);
    rfid2.PICC_HaltA();
    delay(500);
  }

  for (int i = 0; i < 2; i++) {
    int s = digitalRead(startButtons[i]);
    int e = digitalRead(endButtons[i]);

    if (s == LOW && startState[i] == HIGH) {
      Serial.print("Machine ");
      Serial.print(i + 1);
      Serial.println(" START");
      sendLog(i, "start");
      startState[i] = LOW;
    }
    if (s == HIGH) startState[i] = HIGH;

    if (e == LOW && endState[i] == HIGH) {
      Serial.print("Machine ");
      Serial.print(i + 1);
      Serial.println(" END");
      sendLog(i, "end");
      endState[i] = LOW;
    }
    if (e == HIGH) endState[i] = HIGH;
  }

  delay(50);
}