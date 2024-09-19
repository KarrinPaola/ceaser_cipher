import 'package:flutter/material.dart';
import 'dart:math';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(length: 3, child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(tabs: [
            Tab(text: 'Ceasar Cipher'),
            Tab(text: 'Sub Cipher',),
            Tab(text: 'Affine')
          ]),
        ),
        body: TabBarView(children: [
          CeaserCiper(),
          CipherPage(),
          AffineCipherPage()
        ]),
      ))
    );
  }
}

class CeaserCiper extends StatefulWidget {
  const CeaserCiper({super.key});

  @override
  _CeaserCiperState createState() => _CeaserCiperState();
}

class _CeaserCiperState extends State<CeaserCiper> {
  TextEditingController textController1 = TextEditingController(); // Nhập chuỗi
  TextEditingController textController2 = TextEditingController(); // Hiển thị kết quả
  TextEditingController shiftController = TextEditingController(); // Nhập bước nhảy (shift)

  String resultText = ""; // Biến để lưu trữ kết quả

  // Hàm mã hóa Caesar Cipher
  String _caesarEncrypt(String input, int shift) {
    return String.fromCharCodes(input.codeUnits.map((unit) {
      return (unit + shift) % 256; // Áp dụng dịch chuyển cho toàn bộ mã ASCII
    }));
  }

  // Hàm giải mã Caesar Cipher
  String _caesarDecrypt(String input, int shift) {
    return String.fromCharCodes(input.codeUnits.map((unit) {
      return (unit - shift + 256) % 256; // Dịch ngược lại cho toàn bộ mã ASCII
    }));
  }

  // Hàm xử lý khi nhấn nút "Giải mã"
  void _onButtonDecryptPressed() {
    int shift = int.tryParse(shiftController.text) ?? 3; // Sử dụng bước nhảy nhập từ TextField
    setState(() {
      resultText = _caesarDecrypt(textController1.text, shift);
      textController2.text = resultText;
    });
  }

  // Hàm xử lý khi nhấn nút "Mã hoá"
  void _onButtonEncryptPressed() {
    int shift = int.tryParse(shiftController.text) ?? 3; // Sử dụng bước nhảy nhập từ TextField
    setState(() {
      resultText = _caesarEncrypt(textController1.text, shift);
      textController2.text = resultText;
    });
  }

  // Hàm xử lý khi nhấn nút "Xoá"
  void _onButtonClearPressed() {
    setState(() {
      textController1.clear();
      textController2.clear();
      shiftController.clear();
      resultText = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Caesar Cipher Demo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Row chứa TextField để nhập chuỗi và TextField để nhập bước nhảy
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController1,
                    decoration: const InputDecoration(
                      labelText: "Nhập chuỗi",
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: shiftController,
                    decoration: const InputDecoration(
                      labelText: "Bước nhảy",
                    ),
                    keyboardType: TextInputType.number, // Chỉ cho phép nhập số
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Button "Giải mã"
                  ElevatedButton(
                    onPressed: _onButtonDecryptPressed,
                    child: const Text("Giải mã"),
                  ),
                  // Button "Mã hóa"
                  ElevatedButton(
                    onPressed: _onButtonEncryptPressed,
                    child: const Text("Mã hóa"),
                  ),
                  // Button "Xoá"
                  ElevatedButton(
                    onPressed: _onButtonClearPressed,
                    child: const Text("Xoá"),
                  ),
                ],
              ),
            ),
            // TextField 2 để hiển thị kết quả
            TextField(
              controller: textController2,
              enabled: false, // Không cho phép nhập liệu vào TextField 2
              decoration: const InputDecoration(
                labelText: "Kết quả",
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class CipherPage extends StatefulWidget {
  @override
  _CipherPageState createState() => _CipherPageState();
}

class _CipherPageState extends State<CipherPage> {
  // Các biến để lưu bảng thay thế và văn bản
  Map<String, String> substitutionTable = {};
  String inputText = '';
  String encryptedText = '';
  String decryptedText = '';

  // Hàm tạo bảng thay thế ngẫu nhiên
  Map<String, String> taoBangThayThe() {
    List<String> alphabet = 'abcdefghijklmnopqrstuvwxyz'.split('');
    List<String> shuffledAlphabet = List.from(alphabet)..shuffle(Random());

    Map<String, String> table = {};
    for (int i = 0; i < alphabet.length; i++) {
      table[alphabet[i]] = shuffledAlphabet[i];
    }

    return table;
  }

  // Hàm mã hóa
  String maHoa(String input, Map<String, String> table) {
    String encrypted = '';
    for (var char in input.toLowerCase().split('')) {
      if (table.containsKey(char)) {
        encrypted += table[char]!;
      } else {
        encrypted += char;
      }
    }
    return encrypted;
  }

  // Hàm giải mã
  String giaiMa(String input, Map<String, String> table) {
    Map<String, String> reverseTable = {
      for (var entry in table.entries) entry.value: entry.key
    };
    String decrypted = '';
    for (var char in input.toLowerCase().split('')) {
      if (reverseTable.containsKey(char)) {
        decrypted += reverseTable[char]!;
      } else {
        decrypted += char;
      }
    }
    return decrypted;
  }

  // Xử lý khi người dùng nhấn nút Mã hóa
  void handleEncrypt() {
    setState(() {
      substitutionTable = taoBangThayThe();
      encryptedText = maHoa(inputText, substitutionTable);
      decryptedText = ''; // Xóa văn bản giải mã khi mã hóa
    });
  }

  // Xử lý khi người dùng nhấn nút Giải mã
  void handleDecrypt() {
    setState(() {
      decryptedText = giaiMa(encryptedText, substitutionTable);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Substitution Cipher'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Văn bản cần mã hóa'),
              onChanged: (text) {
                inputText = text;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleEncrypt,
              child: Text('Mã hóa'),
            ),
            SizedBox(height: 20),
            Text(
              'Văn bản mã hóa:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(encryptedText),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleDecrypt,
              child: Text('Giải mã'),
            ),
            SizedBox(height: 20),
            Text(
              'Văn bản giải mã:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(decryptedText),
          ],
        ),
      ),
    );
  }
}


class AffineCipherPage extends StatefulWidget {
  @override
  _AffineCipherPageState createState() => _AffineCipherPageState();
}

class _AffineCipherPageState extends State<AffineCipherPage> {
  final int m = 26; // Độ dài bảng chữ cái
  int a = 5; // Hệ số a (gcd(a, 26) = 1)
  int b = 8; // Hệ số b
  String inputText = '';
  String encryptedText = '';
  String decryptedText = '';

  // Hàm tính nghịch đảo modular của a
  int modInverse(int a, int m) {
    for (int x = 1; x < m; x++) {
      if ((a * x) % m == 1) {
        return x;
      }
    }
    throw Exception("a không có nghịch đảo modular");
  }

  // Hàm mã hóa Affine
  String maHoa(String input, int a, int b) {
    String encrypted = '';
    for (var char in input.toLowerCase().split('')) {
      if (RegExp(r'[a-z]').hasMatch(char)) {
        int x = char.codeUnitAt(0) - 'a'.codeUnitAt(0); // Lấy chỉ số ký tự trong bảng chữ cái
        int encryptedChar = (a * x + b) % m; // Công thức mã hóa
        encrypted += String.fromCharCode(encryptedChar + 'a'.codeUnitAt(0)); // Chuyển về ký tự
      } else {
        encrypted += char; // Giữ nguyên các ký tự không phải chữ
      }
    }
    return encrypted;
  }

  // Hàm giải mã Affine
  String giaiMa(String input, int a, int b) {
    String decrypted = '';
    int a_inv = modInverse(a, m); // Tìm nghịch đảo của a
    for (var char in input.toLowerCase().split('')) {
      if (RegExp(r'[a-z]').hasMatch(char)) {
        int y = char.codeUnitAt(0) - 'a'.codeUnitAt(0); // Lấy chỉ số ký tự trong bảng chữ cái
        int decryptedChar = (a_inv * (y - b)) % m; // Công thức giải mã
        if (decryptedChar < 0) {
          decryptedChar += m; // Đảm bảo kết quả không âm
        }
        decrypted += String.fromCharCode(decryptedChar + 'a'.codeUnitAt(0)); // Chuyển về ký tự
      } else {
        decrypted += char; // Giữ nguyên các ký tự không phải chữ
      }
    }
    return decrypted;
  }

  // Xử lý mã hóa
  void handleEncrypt() {
    setState(() {
      encryptedText = maHoa(inputText, a, b);
      decryptedText = ''; // Xóa văn bản giải mã khi mã hóa
    });
  }

  // Xử lý giải mã
  void handleDecrypt() {
    setState(() {
      decryptedText = giaiMa(encryptedText, a, b);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Affine Cipher'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Văn bản cần mã hóa'),
              onChanged: (text) {
                inputText = text;
              },
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(labelText: 'Hệ số a'),
              keyboardType: TextInputType.number,
              onChanged: (text) {
                a = int.parse(text);
              },
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(labelText: 'Hệ số b'),
              keyboardType: TextInputType.number,
              onChanged: (text) {
                b = int.parse(text);
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleEncrypt,
              child: Text('Mã hóa'),
            ),
            SizedBox(height: 20),
            Text(
              'Văn bản mã hóa:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(encryptedText),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleDecrypt,
              child: Text('Giải mã'),
            ),
            SizedBox(height: 20),
            Text(
              'Văn bản giải mã:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(decryptedText),
          ],
        ),
      ),
    );
  }
}
