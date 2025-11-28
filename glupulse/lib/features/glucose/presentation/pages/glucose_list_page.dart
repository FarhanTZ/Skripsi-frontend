import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:glupulse/features/glucose/domain/entities/glucose.dart';
import 'package:glupulse/features/HealthData/domain/entities/health_profile.dart';
import 'package:glupulse/features/HealthData/presentation/cubit/health_profile_state.dart';
import 'package:glupulse/features/HealthData/presentation/cubit/health_profile_cubit.dart';
import 'package:glupulse/features/glucose/presentation/cubit/glucose_cubit.dart';
import 'package:glupulse/features/glucose/presentation/pages/add_edit_glucose_page.dart';
import 'package:glupulse/features/glucose/presentation/pages/glucose_history_page.dart';

class GlucoseListPage extends StatefulWidget {
  const GlucoseListPage({super.key});

  @override
  State<GlucoseListPage> createState() => _GlucoseListPageState();
}

class _GlucoseListPageState extends State<GlucoseListPage> {
  DateTime _selectedDate = DateTime.now(); // State untuk tanggal yang dipilih

  @override
  void initState() {
    super.initState();
    _fetchGlucoseRecords();
    _fetchHealthProfile();
  }

  Future<void> _fetchGlucoseRecords() async {
    context.read<GlucoseCubit>().getGlucoseRecords();
  }

  Future<void> _fetchHealthProfile() async {
    context.read<HealthProfileCubit>().fetchHealthProfile();
  }

  void _navigateToInputPage({Glucose? glucose}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => InputGlucosePage(glucose: glucose),
      ),
    );
  }

  Color _trendColor(String? trend) {
    switch (trend) {
      case "rising_rapidly":
      case "rising":
        return Colors.red;
      case "falling_rapidly":
      case "falling":
        return Colors.orange;
      case "stable":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _trendIcon(String? trend) {
    switch (trend) {
      case "rising_rapidly":
        return Icons.keyboard_double_arrow_up;
      case "rising":
        return Icons.keyboard_arrow_up;
      case "falling_rapidly":
        return Icons.keyboard_double_arrow_down;
      case "falling":
        return Icons.keyboard_arrow_down;
      case "stable":
        return Icons.horizontal_rule;
      default:
        return Icons.help_outline;
    }
  }

  // --- Widget Selector Bulan & Tahun ---
  Widget _buildDateSelector() {
    return Column(
      children: [
        // Selector Tahun
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  setState(() {
                    _selectedDate = DateTime(_selectedDate.year - 1, _selectedDate.month);
                  });
                },
              ),
              Text(
                DateFormat('yyyy').format(_selectedDate),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  setState(() {
                    _selectedDate = DateTime(_selectedDate.year + 1, _selectedDate.month);
                  });
                },
              ),
            ],
          ),
        ),
        // Selector Bulan (Horizontal Scroll)
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 12,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            itemBuilder: (context, index) {
              final monthIndex = index + 1;
              final isSelected = monthIndex == _selectedDate.month;
              final date = DateTime(_selectedDate.year, monthIndex);
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = DateTime(_selectedDate.year, monthIndex);
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: isSelected 
                      ? null 
                      : Border.all(color: Colors.grey.shade300),
                  ),
                  child: Center(
                    child: Text(
                      DateFormat('MMM').format(date),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey.shade700,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSymptomsChips(List<String> symptoms) {
    if (symptoms.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Wrap(
          spacing: 6.0,
          runSpacing: 4.0,
          children: symptoms.map((symptom) {
            return Chip(
              avatar: Icon(Icons.local_fire_department_outlined, size: 16, color: Colors.orange.shade800),
              label: Text(
                symptom.replaceAll('_', ' '),
                style: TextStyle(color: Colors.orange.shade900, fontSize: 12),
              ),
              backgroundColor: Colors.orange.shade50,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildLatestSymptomsSection(Glucose latestRecord) {
    if (latestRecord.symptoms == null || latestRecord.symptoms!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Symptoms',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: _buildSymptomsChips(latestRecord.symptoms!),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetCard(String title, int? value, IconData icon, Color iconColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              value != null ? '$value' : 'N/A',
              style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 12, height: 1.3),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTargetRangesSection(HealthProfile profile) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
      child: Row(
        children: [
          _buildTargetCard('Fasting Target', profile.targetGlucoseFasting, Icons.wb_sunny_outlined, Colors.blue.shade600),
          const SizedBox(width: 16),
          _buildTargetCard('Post-Meal Target', profile.targetGlucosePostprandial, Icons.restaurant_menu_outlined, Colors.orange.shade600),
        ],
      ),
    );
  }

  Widget _buildChart(List<Glucose> records) {
    if (records.isEmpty) {
       return Container(
        height: 220,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(child: Text("No data for this month")),
      );
    }

    // Sort data by date ascending for the chart
    final sortedRecords = List<Glucose>.from(records)
      ..sort((a, b) => a.readingTimestamp.compareTo(b.readingTimestamp));

    // Gunakan semua data bulan ini untuk chart, tidak perlu di-limit 10 jika user ingin lihat sebulan penuh
    // Namun jika terlalu banyak, label bisa bertumpuk. FlChart menangani plotting, kita atur label.
    final chartData = sortedRecords;

    List<FlSpot> spots = chartData.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.glucoseValue.toDouble());
    }).toList();

    return Container(
      height: 220,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 50,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.shade200,
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1, // Interval 1 index
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index >= 0 && index < chartData.length) {
                    // Logika sederhana untuk menampilkan label agar tidak bertumpuk
                    // Tampilkan awal, tengah, akhir, atau setiap n item tergantung jumlah data
                    bool showLabel = false;
                    if (chartData.length <= 7) {
                      showLabel = true; // Tampilkan semua jika sedikit
                    } else {
                      // Tampilkan index 0, index terakhir, dan kelipatan tertentu
                      if (index == 0 || index == chartData.length - 1 || index % (chartData.length ~/ 5 + 1) == 0) {
                        showLabel = true;
                      }
                    }

                    if (showLabel) {
                       return Padding(
                         padding: const EdgeInsets.only(top: 8.0),
                         child: Text(
                          DateFormat('dd/MM').format(chartData[index].readingTimestamp.toLocal()),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                       );
                    }
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 50,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  const style = TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  );
                  String text;
                  switch (value.toInt()) {
                    case 0:
                      text = '0';
                      break;
                    case 50:
                      text = '50';
                      break;
                    case 100:
                      text = '100';
                      break;
                    case 200:
                      text = '200';
                      break;
                    case 300:
                      text = '300';
                      break;
                    case 400:
                      text = '400';
                      break;
                    default:
                      return const SizedBox.shrink();
                  }
                  return Text(text, style: style);
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          minX: 0,
          maxX: (chartData.length - 1).toDouble(),
          minY: 0,
          maxY: 400.0,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withOpacity(0.5),
                ],
              ),
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: Colors.white,
                    strokeWidth: 2,
                    strokeColor: Theme.of(context).colorScheme.primary,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    Theme.of(context).colorScheme.primary.withOpacity(0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToInputPage(),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const Text(
                      'Glucose Reading',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              
              // --- Selector Tanggal (Bulan & Tahun) ---
              _buildDateSelector(),

              BlocBuilder<GlucoseCubit, GlucoseState>(
                builder: (context, state) {
                  List<Glucose> filteredRecords = [];
                  Glucose? latestRecord;

                  if (state is GlucoseLoaded) {
                     // Filter data berdasarkan bulan dan tahun yang dipilih
                     filteredRecords = state.glucoseRecords.where((record) {
                       return record.readingTimestamp.month == _selectedDate.month &&
                              record.readingTimestamp.year == _selectedDate.year;
                     }).toList();

                     // Ambil record terbaru secara umum (tanpa filter) untuk bagian "Last Glucose Reading"
                     // Atau jika ingin "Last Record of Selected Month", gunakan filteredRecords.
                     // Biasanya user ingin lihat status *terkini* di summary, tapi chart melihat history.
                     // Kita gunakan latestRecord dari SELURUH data untuk widget "Last Reading",
                     // tapi chart menggunakan data terfilter.
                     if (state.glucoseRecords.isNotEmpty) {
                       latestRecord = state.glucoseRecords.first;
                     }
                  }

                  return Column(
                    children: [
                      // --- Grafik (Chart) dengan Data Terfilter ---
                      _buildChart(filteredRecords),

                      // --- Last Glucose Reading (General Latest) ---
                      if (latestRecord != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: latestRecord.glucoseValue.toString(),
                                          style: const TextStyle(fontSize: 75),
                                        ),
                                        const TextSpan(
                                          text: ' mg/dL',
                                          style: TextStyle(
                                              fontSize: 20, fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Icon(_trendIcon(latestRecord.trendArrow),
                                      color: _trendColor(latestRecord.trendArrow), size: 40),
                                ],
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Last Glucose Reading',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        )
                      else if (state is! GlucoseLoading && state is! GlucoseError)
                         const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32.0),
                          child: Text("No data available."),
                        ),
                      
              // --- Bagian Target Glukosa dari Health Profile ---
              const Padding(
                padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Main Overview',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              BlocBuilder<HealthProfileCubit, HealthProfileState>(
                builder: (context, state) {
                          if (state is HealthProfileLoaded) {
                            return _buildTargetRangesSection(state.healthProfile);
                          }
                          return const SizedBox.shrink();
                        },
                      ),

                      // --- Bagian Symptoms Terbaru ---
                      if (latestRecord != null)
                        _buildLatestSymptomsSection(latestRecord),
                    ],
                  );
                },
              ),

              // --- Judul History & Lihat Semua ---
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'History',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const GlucoseHistoryPage(),
                        ));
                      },
                      child: const Text('Lihat Semua'),
                    ),
                  ],
                ),
              ),
              
              // --- List History (Terfilter juga agar konsisten dengan chart) ---
              BlocConsumer<GlucoseCubit, GlucoseState>(
                listener: (context, state) {
                  if (state is GlucoseAdded || state is GlucoseUpdated || state is GlucoseDeleted) {
                    _fetchGlucoseRecords();
                    // Tampilkan snackbar sesuai event (kode lama)
                     String msg = 'Success';
                     if (state is GlucoseAdded) msg = 'Glucose data added successfully';
                     else if (state is GlucoseUpdated) msg = 'Glucose data updated successfully';
                     else if (state is GlucoseDeleted) msg = 'Glucose data deleted successfully';
                     
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                  } else if (state is GlucoseError) {
                     ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is GlucoseLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is GlucoseLoaded) {
                    // Filter list juga agar konsisten dengan tampilan bulan yang dipilih
                    var filteredList = state.glucoseRecords.where((record) {
                       return record.readingTimestamp.month == _selectedDate.month &&
                              record.readingTimestamp.year == _selectedDate.year;
                     }).toList();

                    // Sort descending (terbaru di atas)
                    filteredList.sort((a, b) => b.readingTimestamp.compareTo(a.readingTimestamp));

                    // Ambil maksimal 5 data terakhir
                    filteredList = filteredList.take(5).toList();

                    if (filteredList.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 50.0, top: 20.0),
                        child: Center(
                          child: Text('No records found for ${DateFormat('MMMM yyyy').format(_selectedDate)}.'),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final record = filteredList[index];
                        return Dismissible(
                          key: Key(record.readingId!),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (direction) async {
                            return await showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Confirm Delete'),
                                content: const Text(
                                    'Are you sure you want to delete this record?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('No'),
                                    onPressed: () => Navigator.of(ctx).pop(false),
                                  ),
                                  TextButton(
                                    child: const Text('Yes'),
                                    onPressed: () => Navigator.of(ctx).pop(true),
                                  ),
                                ],
                              ),
                            );
                          },
                          onDismissed: (direction) {
                            context
                                .read<GlucoseCubit>()
                                .deleteGlucose(record.readingId!);
                          },
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20.0),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          child: Card(
                            color: Colors.white,
                            margin: const EdgeInsets.only(bottom: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            elevation: 4,
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              onTap: () => _navigateToInputPage(glucose: record),
                              child: IntrinsicHeight(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      color: const Color(0xFF0F67FE),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 16),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                            Text(
                                            "${record.glucoseValue}",
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const Text(
                                            "mg/dL",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white70,
                                            ),
                                          )
                                        ]
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              record.readingType.replaceAll('_', ' ').toUpperCase(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            ),
                                            const SizedBox(height: 4),
                                  Text(
                                    DateFormat('dd MMM yyyy, HH:mm').format(record.readingTimestamp.toLocal()),
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                            if (record.deviceName != null && record.deviceName!.isNotEmpty) ...[
                                              const SizedBox(height: 4),
                                              Text(
                                                "Device: ${record.deviceName!}",
                                                style: const TextStyle(fontSize: 12, color: Colors.black54),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                            if (record.deviceId != null && record.deviceId!.isNotEmpty) ...[
                                              const SizedBox(height: 4),
                                              Text(
                                                "ID: ${record.deviceId!}",
                                                style: const TextStyle(fontSize: 12, color: Colors.black54),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 16.0),
                                      child: Row(
                                          children: [
                                            Icon(_trendIcon(record.trendArrow), color: _trendColor(record.trendArrow)),
                                            const SizedBox(width: 4),
                                            Text(
                                              record.trendArrow ?? "stable",
                                              style: TextStyle(color: _trendColor(record.trendArrow), fontWeight: FontWeight.bold, fontSize: 12),
                                            ),
                                          ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  if (state is GlucoseError) {
                    return const Center(child: Text('Tidak ada data untuk ditampilkan.'));
                  }
                  return const Center(child: Text('Tidak ada data untuk ditampilkan.'));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}