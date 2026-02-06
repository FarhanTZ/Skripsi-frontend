import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// Sebaiknya diletakkan di file terpisah (misal: domain/entities/metric_content.dart)
class MetricContent {
  final List<Map<String, dynamic>> historyData;
  final String explanation;
  final List<String> recommendations;
  final double chartMaxY;

  MetricContent(
      {required this.historyData,
      required this.explanation,
      required this.recommendations,
      required this.chartMaxY});
}

class HealthMetricDetailPage extends StatefulWidget {
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

  @override
  State<HealthMetricDetailPage> createState() => _HealthMetricDetailPageState();
}

class _HealthMetricDetailPageState extends State<HealthMetricDetailPage>
    with TickerProviderStateMixin {
  int touchedIndex = -1;
  late AnimationController _headerAnimationController;
  late Animation<double> _headerAnimation;
  late MetricContent _metricContent; // Gunakan model ini

  @override
  void initState() {
    super.initState();
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _headerAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _headerAnimationController, curve: Curves.easeOut),
    );
    _headerAnimationController.forward();
    _loadMetricData(); // Panggil method untuk memuat data
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    super.dispose();
  }
  
  // Method untuk memusatkan logika pengambilan data
  void _loadMetricData() {
    if (widget.title.contains("Sugar")) {
      _metricContent = MetricContent(
        historyData: [
          {'day': 'Sen', 'value': 100.0, 'fullValue': '100'},
          {'day': 'Sel', 'value': 120.0, 'fullValue': '120'},
          {'day': 'Rab', 'value': 110.0, 'fullValue': '110'},
          {'day': 'Kam', 'value': 140.0, 'fullValue': '140'},
          {'day': 'Jum', 'value': 130.0, 'fullValue': '130'},
          {'day': 'Sab', 'value': 150.0, 'fullValue': '150'},
          {'day': 'Min', 'value': 125.0, 'fullValue': '125'},
        ],
        explanation: 'Gula darah adalah ukuran jumlah glukosa dalam darah Anda. Menjaga kadar gula darah dalam rentang normal sangat penting untuk mencegah komplikasi diabetes dan menjaga energi tubuh tetap stabil.',
        recommendations: [
          'Konsumsi makanan kaya serat seperti oatmeal dan sayuran.',
          'Lakukan aktivitas fisik secara teratur, minimal 30 menit sehari.',
          'Batasi konsumsi gula dan karbohidrat olahan.'
        ],
        chartMaxY: 200,
      );
    } else if (widget.title.contains("BMI")) {
      _metricContent = MetricContent(
        historyData: [
          {'day': 'Sen', 'value': 22.1, 'fullValue': '22.1'},
          {'day': 'Sel', 'value': 22.3, 'fullValue': '22.3'},
          {'day': 'Rab', 'value': 22.2, 'fullValue': '22.2'},
          {'day': 'Kam', 'value': 22.5, 'fullValue': '22.5'},
          {'day': 'Jum', 'value': 22.4, 'fullValue': '22.4'},
          {'day': 'Sab', 'value': 22.6, 'fullValue': '22.6'},
          {'day': 'Min', 'value': 22.5, 'fullValue': '22.5'},
        ],
        explanation: 'Indeks Massa Tubuh (IMT) atau Body Mass Index (BMI) adalah ukuran yang digunakan untuk menilai apakah berat badan Anda ideal. Ini dihitung berdasarkan tinggi dan berat badan Anda.',
        recommendations: [
          'Pertahankan pola makan seimbang dengan gizi yang cukup.',
          'Lakukan olahraga secara teratur untuk menjaga berat badan ideal.',
          'Pastikan istirahat yang cukup setiap malam.'
        ],
        chartMaxY: 40,
      );
    } else if (widget.title.contains("Heart Rate")) {
      _metricContent = MetricContent(
        historyData: [
          {'day': 'Sen', 'value': 70.0, 'fullValue': '70'},
          {'day': 'Sel', 'value': 72.0, 'fullValue': '72'},
          {'day': 'Rab', 'value': 68.0, 'fullValue': '68'},
          {'day': 'Kam', 'value': 75.0, 'fullValue': '75'},
          {'day': 'Jum', 'value': 71.0, 'fullValue': '71'},
          {'day': 'Sab', 'value': 73.0, 'fullValue': '73'},
          {'day': 'Min', 'value': 72.0, 'fullValue': '72'},
        ],
        explanation: 'Detak jantung istirahat adalah jumlah detak jantung per menit saat Anda sedang beristirahat. Ini adalah indikator penting dari kesehatan kardiovaskular Anda secara umum.',
        recommendations: [
          'Lakukan olahraga aerobik secara teratur seperti jogging atau berenang.',
          'Kelola stres melalui teknik relaksasi seperti meditasi atau yoga.',
          'Hindari merokok dan batasi konsumsi kafein.'
        ],
        chartMaxY: 100,
      );
    } else {
      _metricContent = MetricContent(
        historyData: [
          {'day': 'Sen', 'value': 120.0, 'fullValue': '120/80'},
          {'day': 'Sel', 'value': 122.0, 'fullValue': '122/81'},
          {'day': 'Rab', 'value': 118.0, 'fullValue': '118/78'},
          {'day': 'Kam', 'value': 125.0, 'fullValue': '125/85'},
          {'day': 'Jum', 'value': 123.0, 'fullValue': '123/82'},
          {'day': 'Sab', 'value': 128.0, 'fullValue': '128/88'},
          {'day': 'Min', 'value': 124.0, 'fullValue': '124/84'},
        ],
        explanation: 'Tekanan darah adalah kekuatan darah yang mendorong dinding arteri. Tekanan darah yang normal penting untuk kesehatan jantung dan mencegah risiko stroke serta penyakit ginjal.',
        recommendations: [
          'Kurangi asupan garam (natrium).',
          'Konsumsi makanan kaya kalium seperti pisang dan bayam.',
          'Lakukan olahraga kardio seperti berjalan cepat atau berlari.'
        ],
        chartMaxY: 160,
      );
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
          'Detail ${widget.title}',
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
            _buildAnimatedHeader(context),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Riwayat Terakhir'),
                  const SizedBox(height: 12),
                  _buildChartCard(context),
                  const SizedBox(height: 28),
                  _buildSectionTitle('Penjelasan'),
                  const SizedBox(height: 12),
                  _buildInfoSectionCard(
                    context,
                    _metricContent.explanation,
                    Icons.info_outline,
                    Colors.blue,
                  ),
                  const SizedBox(height: 28),
                  _buildSectionTitle('Rekomendasi'),
                  const SizedBox(height: 12),
                  _buildInfoSectionCard(
                    context,
                    _metricContent.recommendations,
                    Icons.lightbulb_outline,
                    Colors.amber,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildAnimatedHeader(BuildContext context) {
    return ScaleTransition(
      scale: _headerAnimation,
      child: Container(
        padding: const EdgeInsets.only(top: 100, bottom: 40, left: 24, right: 24),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
            ],
          ),
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(50),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.iconColor.withValues(alpha: 0.3),
                    widget.iconColor.withValues(alpha: 0.1),
                  ],
                ),
              ),
              child: Icon(
                widget.icon,
                color: Colors.white,
                size: 50,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 56,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
              ),
              child: Text(
                '${widget.unit} • ${widget.status}',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.95),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard(BuildContext context) {
    return Card(
      elevation: 8,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      shadowColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: SizedBox(
          height: 240,
          child: _buildChart(context),
        ),
      ),
    );
  }

  Widget _buildInfoSectionCard<T>(
    BuildContext context,
    T content,
    IconData icon,
    Color accentColor,
  ) {
    return Card(
      elevation: 6,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      shadowColor: accentColor.withValues(alpha: 0.15),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            if (content is String)
              Text(
                content,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  height: 1.6,
                  fontWeight: FontWeight.w500,
                ),
              )
            else if (content is List<String>)
              Column(
                children: (content).asMap().entries.map((entry) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: entry.key != content.length - 1 ? 12.0 : 0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            entry.value,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                              height: 1.4,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => widget.iconColor,
            tooltipHorizontalAlignment: FLHorizontalAlignment.center,
            tooltipMargin: 10,
            tooltipRoundedRadius: 12,
            tooltipPadding: const EdgeInsets.all(12),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final historyItem = _metricContent.historyData[group.x.toInt()];
              return BarTooltipItem(
                '${historyItem['fullValue']}\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: widget.unit,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            },
          ),
          touchCallback: (FlTouchEvent event, barTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  barTouchResponse == null ||
                  barTouchResponse.spot == null) {
                touchedIndex = -1;
                return;
              }
              touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
            });
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getTitles,
              reservedSize: 40,
            ),
          ),
          leftTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: showingGroups(),
        gridData: const FlGridData(show: false),
      ),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black45,
      fontWeight: FontWeight.w600,
      fontSize: 14,
    );
    String text = _metricContent.historyData[value.toInt()]['day'];
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: Text(text, style: style),
    );
  }

  List<BarChartGroupData> showingGroups() =>
      List.generate(_metricContent.historyData.length, (i) {
        final item = _metricContent.historyData[i];
        return makeGroupData(i, item['value'], isTouched: i == touchedIndex);
      });

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    double width = 16,
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: isTouched
              ? widget.iconColor
              : widget.iconColor.withValues(alpha: 0.6),
          width: width,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
          borderSide: isTouched
              ? BorderSide(color: widget.iconColor.withValues(alpha: 0.9), width: 3)
              : BorderSide.none,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: _metricContent.chartMaxY,
            color: widget.iconColor.withValues(alpha: 0.08),
          ),
        ),
      ],
    );
  }
}