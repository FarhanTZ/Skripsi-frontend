# Panduan Konversi String Mermaid ke Gambar menggunakan Python

Panduan ini menjelaskan cara membuat skrip Python untuk mengubah string diagram (format Mermaid) menjadi file gambar (PNG, SVG, PDF).

Metode yang paling **andal dan berkualitas tinggi** adalah menggunakan **Mermaid CLI (mmdc)** yang dipanggil melalui Python.

---

## 1. Prasyarat (Instalasi Tools)

Karena library core Mermaid berbasis JavaScript, kita memerlukan **Node.js** untuk merender diagram secara lokal.

1.  **Instal Node.js**: Unduh dan instal dari [nodejs.org](https://nodejs.org/).
2.  **Instal Mermaid CLI**: Buka terminal/cmd dan jalankan perintah berikut:
    ```bash
    npm install -g @mermaid-js/mermaid-cli
    ```
3.  **Verifikasi Instalasi**: Ketik `mmdc --version` di terminal. Jika muncul nomor versi, Anda siap lanjut.

---

## 2. Implementasi Python

Berikut adalah skrip Python lengkap yang membungkus perintah `mmdc`.

Buat file baru, misalnya `generate_diagram.py`:

```python
import subprocess
import os

def render_mermaid(mermaid_string, output_filename, format="png", theme="default"):
    """
    Mengonversi string Mermaid menjadi file gambar menggunakan mmdc.
    
    Args:
        mermaid_string (str): Kode diagram Mermaid.
        output_filename (str): Path file output (contoh: 'diagram.png').
        format (str): Format output ('png', 'svg', 'pdf'). Default 'png'.
        theme (str): Tema diagram ('default', 'forest', 'dark', 'neutral').
    """
    
    # 1. Tentukan nama file sementara untuk input
    temp_input = "temp_diagram.mmd"
    
    # 2. Tulis string mermaid ke file sementara
    # Encoding utf-8 penting untuk karakter khusus
    with open(temp_input, "w", encoding="utf-8") as f:
        f.write(mermaid_string)
        
    # 3. Susun perintah command line
    # Format perintah: mmdc -i <input> -o <output> -t <theme>
    command = [
        "mmdc", 
        "-i", temp_input, 
        "-o", output_filename,
        "-t", theme,
        "-b", "transparent" # Opsi background transparan
    ]
    
    # Tambahkan opsi format jika spesifik (mmdc mendeteksi dari ekstensi, tapi bisa dipaksa)
    # command.extend(["-f", format])

    try:
        print(f"Sedang merender {output_filename}...")
        
        # 4. Jalankan perintah menggunakan subprocess
        # shell=True diperlukan di Windows untuk menemukan path npm global kadang-kadang, 
        # tapi shell=False lebih aman jika path sudah benar. 
        # Di Windows, gunakan 'mmdc.cmd' jika 'mmdc' saja gagal.
        executable = "mmdc.cmd" if os.name == 'nt' else "mmdc"
        
        # Override command[0] dengan executable yang benar
        command[0] = executable
        
        result = subprocess.run(
            command, 
            check=True, 
            capture_output=True, 
            text=True
        )
        
        print(f"✅ Berhasil! Gambar disimpan di: {os.path.abspath(output_filename)}")
        
    except subprocess.CalledProcessError as e:
        print(f"❌ Terjadi kesalahan saat merender:")
        print(f"STDERR: {e.stderr}")
    except FileNotFoundError:
        print("❌ Error: Perintah 'mmdc' tidak ditemukan. Pastikan sudah install: npm install -g @mermaid-js/mermaid-cli")
    finally:
        # 5. Bersihkan file sementara
        if os.path.exists(temp_input):
            os.remove(temp_input)

# --- CONTOH PENGGUNAAN ---

if __name__ == "__main__":
    # Contoh String dari Sequence Diagram Anda
    diagram_code = """
    sequenceDiagram
        participant U as User
        participant BE as Backend
        
        U->>BE: Request Login
        BE-->>U: Return Token
    """

    # Panggil Fungsi
    render_mermaid(diagram_code, "hasil_login.png", theme="forest")
    
    # Contoh 2: Batch Processing (Looping)
    use_cases = [
        ("Login", "sequenceDiagram\nUser->>System: Login\nSystem-->>User: OK"),
        ("Logout", "sequenceDiagram\nUser->>System: Logout\nSystem-->>User: Bye")
    ]
    
    for name, code in use_cases:
        render_mermaid(code, f"{name.lower()}.png")
```

---

## 3. Alternatif Tanpa Instalasi (Menggunakan API)

Jika Anda **tidak ingin menginstal Node.js**, Anda bisa menggunakan API publik (seperti `kroki.io` atau `mermaid.ink`).
*Kelemahan: Membutuhkan koneksi internet dan mengirim data diagram ke server pihak ketiga.*

```python
import base64
import requests

def render_mermaid_api(mermaid_string, output_filename):
    # Encode string ke base64
    graphbytes = mermaid_string.encode("utf8")
    base64_bytes = base64.urlsafe_b64encode(graphbytes)
    base64_string = base64_bytes.decode("ascii")
    
    # URL API (menggunakan mermaid.ink)
    url = "https://mermaid.ink/img/" + base64_string
    
    print(f"Mengunduh gambar dari {url}...")
    response = requests.get(url)
    
    if response.status_code == 200:
        with open(output_filename, 'wb') as f:
            f.write(response.content)
        print(f"✅ Gambar disimpan: {output_filename}")
    else:
        print("❌ Gagal mengambil gambar dari API")

# Contoh
code = "graph TD; A-->B;"
render_mermaid_api(code, "api_result.png")
```

## Ringkasan

| Metode | Kelebihan | Kekurangan |
| :--- | :--- | :--- |
| **Mermaid CLI (Subprocess)** | Hasil resolusi tinggi, Cepat, Offline, Aman (Privasi). | Butuh instal Node.js & NPM. |
| **API Web (Requests)** | Sangat mudah, Tanpa instalasi tambahan. | Butuh Internet, Tidak cocok untuk data rahasia. |
