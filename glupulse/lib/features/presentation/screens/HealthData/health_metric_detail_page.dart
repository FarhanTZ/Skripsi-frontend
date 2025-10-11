import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HealthMetricDetailPage extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final String status;
  final IconData icon;
  final Color iconColor;

  const HealthMetricDetailPage({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.status,
    required this.icon,
    required this.iconColor,
  });

  // Data dummy untuk riwayat
  List<Map<String, dynamic>> get _historyData {
    if (title.contains("Sugar")) {
      // Data untuk 7 hari (Senin - Minggu)
      return [
        {'day': 'Sen', 'value': 100.0, 'fullValue': '100'},
        {'day': 'Sel', 'value': 120.0, 'fullValue': '120'},
        {'day': 'Rab', 'value': 110.0, 'fullValue': '110'},
        {'day': 'Kam', 'value': 140.0, 'fullValue': '140'},
        {'day': 'Jum', 'value': 130.0, 'fullValue': '130'},
        {'day': 'Sab', 'value': 150.0, 'fullValue': '150'},
        {'day': 'Min', 'value': 125.0, 'fullValue': '125'},
      ];
    } else {
      return [
        {'day': 'Sen', 'value': 120.0, 'fullValue': '120/80'},
        {'day': 'Sel', 'value': 122.0, 'fullValue': '122/81'},
        {'day': 'Rab', 'value': 118.0, 'fullValue': '118/78'},
        {'day': 'Kam', 'value': 125.0, 'fullValue': '125/85'},
        {'day': 'Jum', 'value': 123.0, 'fullValue': '123/82'},
        {'day': 'Sab', 'value': 128.0, 'fullValue': '128/88'},
        {'day': 'Min', 'value': 124.0, 'fullValue': '124/84'},
      ];
    }
  }

  String get _explanation {
    if (title.contains("Sugar")) {
      return 'Gula darah adalah ukuran jumlah glukosa dalam darah Anda. Menjaga kadar gula darah dalam rentang normal sangat penting untuk mencegah komplikasi diabetes dan menjaga energi tubuh tetap stabil.';
    } else {
      return 'Tekanan darah adalah kekuatan darah yang mendorong dinding arteri. Tekanan darah yang normal penting untuk kesehatan jantung dan mencegah risiko stroke serta penyakit ginjal.';
    }
  }

  String get _recommendations {
    if (title.contains("Sugar")) {
      return '1. Konsumsi makanan kaya serat seperti oatmeal dan sayuran.\n2. Lakukan aktivitas fisik secara teratur, minimal 30 menit sehari.\n3. Batasi konsumsi gula dan karbohidrat olahan.';
    } else {
      return '1. Kurangi asupan garam (natrium).\n2. Konsumsi makanan kaya kalium seperti pisang dan bayam.\n3. Lakukan olahraga kardio seperti berjalan cepat atau berlari.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Detail $title',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header dengan nilai utama
            _buildHeader(context),
            const SizedBox(height: 24),
            // Konten di bawah
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, 'Riwayat Terakhir'),
                  const SizedBox(height: 16), // Spasi sebelum kartu grafik
                  _buildChartCard(context), // Grafik dibungkus dalam kartu
                  const SizedBox(height: 24), // Spasi setelah kartu grafik

                  // Bagian "Penjelasan" dibungkus dalam kartu
                  _buildInfoSectionCard(context, 'Penjelasan', _explanation),
                  const SizedBox(height: 24), // Spasi setelah kartu penjelasan

                  // Bagian "Rekomendasi" dibungkus dalam kartu
                  _buildInfoSectionCard(context, 'Rekomendasi', _recommendations),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 100, bottom: 24, left: 24, right: 24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary, // Kembali ke warna biru solid
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(40),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white.withOpacity(0.1),
            child: Icon(icon, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$unit - $status',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  // Widget helper baru untuk membungkus grafik dalam kartu
  Widget _buildChartCard(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 200,
          child: _buildChart(context),
        ),
      ),
    );
  }

  // Widget helper baru untuk membungkus bagian informasi (penjelasan/rekomendasi) dalam kartu
  Widget _buildInfoSectionCard(BuildContext context, String sectionTitle, String content) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sectionTitle,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 12),
            Text(content, style: const TextStyle(fontSize: 16, color: Colors.black54, height: 1.5)),
          ],
        ),
      ),
    );
  }

  // Widget untuk membuat diagram garis
  Widget _buildChart(BuildContext context) {
    final List<FlSpot> spots = _historyData
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value['value']))
        .toList();

    final gradientColors = [
      iconColor.withOpacity(0.8),
      iconColor,
    ];

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: false, // Menghilangkan grid untuk tampilan lebih bersih
          drawVerticalLine: false,
        ),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles( // Menyembunyikan label di sisi kiri
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < _historyData.length) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      _historyData[index]['day'],
                      style: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            gradient: LinearGradient(colors: gradientColors),
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                // Membuat titik yang disentuh lebih besar
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.white,
                  strokeWidth: 2,
                  strokeColor: iconColor,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        // Menyesuaikan rentang min/max sumbu Y agar grafik terlihat lebih baik
        minY: title.contains("Sugar") ? 50 : 80,
        maxY: title.contains("Sugar") ? 200 : 160,
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          getTouchedSpotIndicator: (barData, spotIndexes) {
            return spotIndexes.map((spotIndex) {
              return TouchedSpotIndicatorData(
                const FlLine(color: Colors.transparent), // Sembunyikan garis indikator default
                FlDotData(
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 8, // Titik yang disentuh lebih besar
                      color: iconColor,
                      strokeWidth: 4,
                      strokeColor: Colors.white,
                    );
                  },
                ),
              );
            }).toList();
          },
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => Theme.of(context).colorScheme.primary,
            tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Padding internal tooltip
            tooltipRoundedRadius: 8,
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final flSpot = barSpot;
                final historyItem = _historyData[flSpot.x.toInt()];
                return LineTooltipItem(
                  '', // Main text bisa kosong jika semua konten ada di children
                  const TextStyle(), // Base style untuk children
                  children: [
                    TextSpan( // Nilai pada baris pertama
                      text: '${historyItem['fullValue']}\n',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),),
                    TextSpan( // Unit pada baris kedua
                      text: unit,
                      style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12, fontWeight: FontWeight.normal),),
                  ],
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}