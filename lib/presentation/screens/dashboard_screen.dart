import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/stat_card.dart';
import '../widgets/expandable_card.dart';
import '../../core/themes/app_theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Mock data for UI demonstration
  final Map<String, dynamic> mockStats = {
    'presentDays': 18,
    'leavesTaken': 5,
    'pendingRequests': 2,
    'avgHours': 7.8,
  };

  final List<Map<String, dynamic>> mockAttendance = [
    {'date': '2024-01-15', 'checkIn': '09:00 AM', 'checkOut': '06:00 PM', 'status': 'Present'},
    {'date': '2024-01-14', 'checkIn': '09:15 AM', 'checkOut': '06:00 PM', 'status': 'Late'},
    {'date': '2024-01-13', 'checkIn': '09:00 AM', 'checkOut': '05:30 PM', 'status': 'Present'},
  ];

  final List<Map<String, dynamic>> mockLeaves = [
    {'type': 'Casual Leave', 'startDate': '2024-01-20', 'endDate': '2024-01-22', 'status': 'Approved', 'days': 3},
    {'type': 'Sick Leave', 'startDate': '2024-01-10', 'endDate': '2024-01-11', 'status': 'Approved', 'days': 2},
    {'type': 'Annual Leave', 'startDate': '2024-02-01', 'endDate': '2024-02-10', 'status': 'Pending', 'days': 10},
  ];

  final List<Map<String, dynamic>> mockHolidays = [
    {'name': 'Republic Day', 'date': '2024-01-26', 'day': 'Friday', 'type': 'Public'},
    {'name': 'Maha Shivaratri', 'date': '2024-03-08', 'day': 'Friday', 'type': 'Public'},
    {'name': 'Holi', 'date': '2024-03-25', 'day': 'Monday', 'type': 'Public'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserHeader(),
              const SizedBox(height: 24),
              _buildStatsGrid(),
              const SizedBox(height: 24),
              _buildAttendanceSection(),
              const SizedBox(height: 16),
              _buildLeaveSection(),
              const SizedBox(height: 16),
              _buildHolidaySection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(
              Icons.person,
              size: 30,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome back,',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'John Doe',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Software Developer',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.notifications_none,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        StatCard(
          title: 'Present Days',
          value: mockStats['presentDays'].toString(),
          subtitle: 'This month',
          icon: Icons.check_circle_outline,
          color: AppTheme.successColor,
        ),
        StatCard(
          title: 'Leaves Taken',
          value: mockStats['leavesTaken'].toString(),
          subtitle: '12 remaining',
          icon: Icons.beach_access,
          color: AppTheme.warningColor,
        ),
        StatCard(
          title: 'Pending Requests',
          value: mockStats['pendingRequests'].toString(),
          subtitle: 'Leave requests',
          icon: Icons.pending_actions,
          color: AppTheme.accentColor,
        ),
        StatCard(
          title: 'Avg Hours/Day',
          value: mockStats['avgHours'].toString(),
          subtitle: 'Working hours',
          icon: Icons.timer,
          color: AppTheme.primaryColor,
        ),
      ],
    );
  }

  Widget _buildAttendanceSection() {
    return ExpandableCard(
      title: 'Recent Attendance',
      icon: Icons.calendar_today,
      color: AppTheme.primaryColor,
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: mockAttendance.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            return _buildAttendanceItem(mockAttendance[index]);
          },
        ),
      ],
    );
  }

  Widget _buildAttendanceItem(Map<String, dynamic> attendance) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: attendance['status'] == 'Present'
                  ? AppTheme.successColor.withOpacity(0.1)
                  : AppTheme.warningColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              attendance['status'] == 'Present' ? Icons.check : Icons.access_time,
              color: attendance['status'] == 'Present'
                  ? AppTheme.successColor
                  : AppTheme.warningColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('EEEE, MMM d').format(DateTime.parse(attendance['date'])),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${attendance['checkIn']} - ${attendance['checkOut']}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: attendance['status'] == 'Present'
                  ? AppTheme.successColor.withOpacity(0.1)
                  : AppTheme.warningColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              attendance['status'],
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: attendance['status'] == 'Present'
                    ? AppTheme.successColor
                    : AppTheme.warningColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveSection() {
    return ExpandableCard(
      title: 'Leave Requests',
      icon: Icons.beach_access,
      color: AppTheme.warningColor,
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: mockLeaves.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            return _buildLeaveItem(mockLeaves[index]);
          },
        ),
      ],
    );
  }

  Widget _buildLeaveItem(Map<String, dynamic> leave) {
    Color statusColor;
    switch (leave['status'].toLowerCase()) {
      case 'approved':
        statusColor = AppTheme.successColor;
        break;
      case 'pending':
        statusColor = AppTheme.warningColor;
        break;
      default:
        statusColor = AppTheme.errorColor;
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  leave['type'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  leave['status'],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${leave['startDate']} to ${leave['endDate']} (${leave['days']} days)',
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHolidaySection() {
    return ExpandableCard(
      title: 'Upcoming Holidays',
      icon: Icons.celebration,
      color: AppTheme.accentColor,
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: mockHolidays.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            return _buildHolidayItem(mockHolidays[index]);
          },
        ),
      ],
    );
  }

  Widget _buildHolidayItem(Map<String, dynamic> holiday) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                DateFormat('d').format(DateTime.parse(holiday['date'])),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accentColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  holiday['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${holiday['day']}, ${DateFormat('MMM d, yyyy').format(DateTime.parse(holiday['date']))}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              holiday['type'],
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}