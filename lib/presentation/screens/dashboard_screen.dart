import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/auth_provider.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/stat_card.dart';
import '../widgets/expandable_card.dart';
import '../../core/themes/app_theme.dart';
import '../../data/models/attendance_model.dart';
import '../../data/models/leave_model.dart';
import '../../data/models/holiday_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().loadDashboardData();
    });
  }

  // Responsive helper methods
  double getResponsiveWidth(BuildContext context, {double small = 0.9, double medium = 0.95, double large = 1.0}) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return small;
    if (width < 900) return medium;
    return large;
  }

  double getResponsiveFontSize(BuildContext context, {double small = 12, double medium = 14, double large = 16}) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return small;
    if (width < 900) return medium;
    return large;
  }

  int getGridCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 2;
    if (width < 900) return 3;
    return 4;
  }

  double getResponsivePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 12;
    if (width < 900) return 16;
    return 24;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final isMediumScreen = screenSize.width >= 600 && screenSize.width < 900;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(
            fontSize: getResponsiveFontSize(context, small: 18, medium: 20, large: 22),
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, size: getResponsiveFontSize(context, small: 20, medium: 22, large: 24)),
            onPressed: () {
              context.read<DashboardProvider>().refreshData();
            },
          ),
          IconButton(
            icon: Icon(Icons.logout, size: getResponsiveFontSize(context, small: 20, medium: 22, large: 24)),
            onPressed: () {
              context.read<AuthProvider>().logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Consumer<DashboardProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                    strokeWidth: getResponsiveFontSize(context, small: 3, medium: 4, large: 4),
                  ),
                  SizedBox(height: getResponsivePadding(context)),
                  Text(
                    'Loading dashboard...',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: getResponsiveFontSize(context, small: 14, medium: 16, large: 18),
                    ),
                  ),
                ],
              ),
            );
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: getResponsiveFontSize(context, small: 48, medium: 64, large: 80),
                    color: AppTheme.errorColor.withOpacity(0.7),
                  ),
                  SizedBox(height: getResponsivePadding(context)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getResponsivePadding(context)),
                    child: Text(
                      provider.errorMessage!,
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: getResponsiveFontSize(context, small: 14, medium: 16, large: 18),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: getResponsivePadding(context)),
                  ElevatedButton(
                    onPressed: () => provider.refreshData(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: getResponsivePadding(context) * 2,
                        vertical: getResponsivePadding(context),
                      ),
                    ),
                    child: Text(
                      'Retry',
                      style: TextStyle(
                        fontSize: getResponsiveFontSize(context, small: 14, medium: 16, large: 18),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => provider.refreshData(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(getResponsivePadding(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserHeader(isSmallScreen, isMediumScreen),
                  SizedBox(height: getResponsivePadding(context) * 1.5),
                  _buildStatsGrid(provider, isSmallScreen),
                  SizedBox(height: getResponsivePadding(context) * 1.5),
                  _buildAttendanceSection(provider, isSmallScreen),
                  SizedBox(height: getResponsivePadding(context)),
                  _buildLeaveSection(provider, isSmallScreen),
                  SizedBox(height: getResponsivePadding(context)),
                  _buildHolidaySection(provider, isSmallScreen),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserHeader(bool isSmallScreen, bool isMediumScreen) {
    final authProvider = context.watch<AuthProvider>();
    final avatarSize = getResponsiveFontSize(context, small: 45, medium: 55, large: 65);
    final iconSize = getResponsiveFontSize(context, small: 22, medium: 26, large: 30);
    final padding = getResponsivePadding(context);
    
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 20),
      ),
      child: isSmallScreen
          ? Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: avatarSize,
                      height: avatarSize,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(avatarSize / 2),
                      ),
                      child: Icon(
                        Icons.person,
                        size: iconSize,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    SizedBox(width: padding),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back,',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: getResponsiveFontSize(context, small: 12, medium: 13, large: 14),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            authProvider.userName ?? 'User',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: getResponsiveFontSize(context, small: 16, medium: 18, large: 20),
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2),
                          Text(
                            authProvider.userEmail ?? 'employee@company.com',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: getResponsiveFontSize(context, small: 11, medium: 12, large: 14),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(padding / 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.notifications_none,
                        color: Colors.white,
                        size: iconSize,
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Row(
              children: [
                Container(
                  width: avatarSize,
                  height: avatarSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(avatarSize / 2),
                  ),
                  child: Icon(
                    Icons.person,
                    size: iconSize,
                    color: AppTheme.primaryColor,
                  ),
                ),
                SizedBox(width: padding),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: getResponsiveFontSize(context, small: 12, medium: 13, large: 14),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        authProvider.userName ?? 'User',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: getResponsiveFontSize(context, small: 18, medium: 19, large: 20),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        authProvider.userEmail ?? 'employee@company.com',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: getResponsiveFontSize(context, small: 12, medium: 13, large: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(padding / 1.5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                    size: iconSize,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatsGrid(DashboardProvider provider, bool isSmallScreen) {
    final crossAxisCount = getGridCrossAxisCount(context);
    final spacing = getResponsivePadding(context);
    final aspectRatio = isSmallScreen ? 1.2 : 1.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statistics',
          style: TextStyle(
            fontSize: getResponsiveFontSize(context, small: 18, medium: 20, large: 22),
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        SizedBox(height: spacing),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          childAspectRatio: aspectRatio,
          children: [
            StatCard(
              title: 'Present Days',
              value: provider.attendanceSummary?.totalPresent.toString() ?? '0',
              subtitle: 'This month',
              icon: Icons.check_circle_outline,
              color: AppTheme.successColor,
            ),
            StatCard(
              title: 'Leaves Taken',
              value: provider.leaveBalance?.usedLeaves.toString() ?? '0',
              subtitle: '${provider.leaveBalance?.annualLeaves ?? 0} remaining',
              icon: Icons.beach_access,
              color: AppTheme.warningColor,
            ),
            StatCard(
              title: 'Pending Requests',
              value: provider.leaves.where((l) => l.status == 'Pending').length.toString(),
              subtitle: 'Leave requests',
              icon: Icons.pending_actions,
              color: AppTheme.accentColor,
            ),
            StatCard(
              title: 'Avg Hours/Day',
              value: provider.attendanceSummary?.averageHours.toStringAsFixed(1) ?? '0',
              subtitle: 'Working hours',
              icon: Icons.timer,
              color: AppTheme.primaryColor,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAttendanceSection(DashboardProvider provider, bool isSmallScreen) {
    final fontSize = getResponsiveFontSize(context);
    final padding = getResponsivePadding(context);
    
    if (provider.attendance.isEmpty) {
      return ExpandableCard(
        title: 'Recent Attendance',
        icon: Icons.calendar_today,
        color: AppTheme.primaryColor,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: padding * 1.5),
            child: Center(
              child: Text(
                'No attendance records found',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return ExpandableCard(
      title: 'Recent Attendance',
      icon: Icons.calendar_today,
      color: AppTheme.primaryColor,
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.attendance.length,
          separatorBuilder: (_, __) => Divider(height: padding),
          itemBuilder: (context, index) {
            final attendance = provider.attendance[index];
            return _buildAttendanceItem(attendance, isSmallScreen);
          },
        ),
      ],
    );
  }

  Widget _buildAttendanceItem(AttendanceModel attendance, bool isSmallScreen) {
    final fontSize = getResponsiveFontSize(context);
    final iconSize = getResponsiveFontSize(context, small: 20, medium: 22, large: 24);
    final containerSize = getResponsiveFontSize(context, small: 40, medium: 45, large: 50);
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 6 : 8),
      child: isSmallScreen
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: containerSize,
                      height: containerSize,
                      decoration: BoxDecoration(
                        color: attendance.status == 'Present'
                            ? AppTheme.successColor.withOpacity(0.1)
                            : attendance.status == 'Late'
                                ? AppTheme.warningColor.withOpacity(0.1)
                                : AppTheme.errorColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        attendance.status == 'Present'
                            ? Icons.check_circle_outline
                            : attendance.status == 'Late'
                                ? Icons.access_time
                                : Icons.cancel_outlined,
                        color: attendance.status == 'Present'
                            ? AppTheme.successColor
                            : attendance.status == 'Late'
                                ? AppTheme.warningColor
                                : AppTheme.errorColor,
                        size: iconSize,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('EEEE, MMM d').format(DateTime.parse(attendance.date)),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: fontSize,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${attendance.checkIn} - ${attendance.checkOut}',
                            style: TextStyle(
                              fontSize: fontSize * 0.85,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: attendance.status == 'Present'
                            ? AppTheme.successColor.withOpacity(0.1)
                            : attendance.status == 'Late'
                                ? AppTheme.warningColor.withOpacity(0.1)
                                : AppTheme.errorColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        attendance.status,
                        style: TextStyle(
                          fontSize: fontSize * 0.8,
                          fontWeight: FontWeight.w600,
                          color: attendance.status == 'Present'
                              ? AppTheme.successColor
                              : attendance.status == 'Late'
                                  ? AppTheme.warningColor
                                  : AppTheme.errorColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Padding(
                  padding: EdgeInsets.only(left: containerSize + 12),
                  child: Text(
                    'Total hours: ${attendance.totalHours} hrs',
                    style: TextStyle(
                      fontSize: fontSize * 0.8,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Container(
                  width: containerSize,
                  height: containerSize,
                  decoration: BoxDecoration(
                    color: attendance.status == 'Present'
                        ? AppTheme.successColor.withOpacity(0.1)
                        : attendance.status == 'Late'
                            ? AppTheme.warningColor.withOpacity(0.1)
                            : AppTheme.errorColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    attendance.status == 'Present'
                        ? Icons.check_circle_outline
                        : attendance.status == 'Late'
                            ? Icons.access_time
                            : Icons.cancel_outlined,
                    color: attendance.status == 'Present'
                        ? AppTheme.successColor
                        : attendance.status == 'Late'
                            ? AppTheme.warningColor
                            : AppTheme.errorColor,
                    size: iconSize,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('EEEE, MMM d').format(DateTime.parse(attendance.date)),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: fontSize,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${attendance.checkIn} - ${attendance.checkOut} • ${attendance.totalHours} hrs',
                        style: TextStyle(
                          fontSize: fontSize * 0.85,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: attendance.status == 'Present'
                        ? AppTheme.successColor.withOpacity(0.1)
                        : attendance.status == 'Late'
                            ? AppTheme.warningColor.withOpacity(0.1)
                            : AppTheme.errorColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    attendance.status,
                    style: TextStyle(
                      fontSize: fontSize * 0.85,
                      fontWeight: FontWeight.w600,
                      color: attendance.status == 'Present'
                          ? AppTheme.successColor
                          : attendance.status == 'Late'
                              ? AppTheme.warningColor
                              : AppTheme.errorColor,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildLeaveSection(DashboardProvider provider, bool isSmallScreen) {
    final fontSize = getResponsiveFontSize(context);
    final padding = getResponsivePadding(context);
    
    if (provider.leaves.isEmpty) {
      return ExpandableCard(
        title: 'Leave Requests',
        icon: Icons.beach_access,
        color: AppTheme.warningColor,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: padding * 1.5),
            child: Center(
              child: Text(
                'No leave requests found',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return ExpandableCard(
      title: 'Leave Requests',
      icon: Icons.beach_access,
      color: AppTheme.warningColor,
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.leaves.length,
          separatorBuilder: (_, __) => Divider(height: padding),
          itemBuilder: (context, index) {
            final leave = provider.leaves[index];
            return _buildLeaveItem(leave, isSmallScreen);
          },
        ),
      ],
    );
  }

  Widget _buildLeaveItem(LeaveModel leave, bool isSmallScreen) {
    final fontSize = getResponsiveFontSize(context);
    
    Color statusColor;
    IconData statusIcon;

    switch (leave.status.toLowerCase()) {
      case 'approved':
        statusColor = AppTheme.successColor;
        statusIcon = Icons.check_circle;
        break;
      case 'pending':
        statusColor = AppTheme.warningColor;
        statusIcon = Icons.pending;
        break;
      default:
        statusColor = AppTheme.errorColor;
        statusIcon = Icons.cancel;
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 6 : 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(statusIcon, color: statusColor, size: fontSize),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        leave.type,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: fontSize,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 8 : 12, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  leave.status,
                  style: TextStyle(
                    fontSize: fontSize * 0.8,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 6 : 8),
          Row(
            children: [
              Icon(Icons.date_range, size: fontSize * 0.8, color: AppTheme.textSecondary),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${_formatDate(leave.startDate)} - ${_formatDate(leave.endDate)} (${leave.days} days)',
                  style: TextStyle(
                    fontSize: fontSize * 0.85,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          if (leave.reason.isNotEmpty) ...[
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.description, size: fontSize * 0.8, color: AppTheme.textSecondary),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    leave.reason,
                    style: TextStyle(
                      fontSize: fontSize * 0.85,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHolidaySection(DashboardProvider provider, bool isSmallScreen) {
    final fontSize = getResponsiveFontSize(context);
    final padding = getResponsivePadding(context);
    
    if (provider.holidays.isEmpty) {
      return ExpandableCard(
        title: 'Upcoming Holidays',
        icon: Icons.celebration,
        color: AppTheme.accentColor,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: padding * 1.5),
            child: Center(
              child: Text(
                'No upcoming holidays',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return ExpandableCard(
      title: 'Upcoming Holidays',
      icon: Icons.celebration,
      color: AppTheme.accentColor,
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.holidays.length,
          separatorBuilder: (_, __) => Divider(height: padding),
          itemBuilder: (context, index) {
            final holiday = provider.holidays[index];
            return _buildHolidayItem(holiday, isSmallScreen);
          },
        ),
      ],
    );
  }

  Widget _buildHolidayItem(HolidayModel holiday, bool isSmallScreen) {
    final holidayDate = DateTime.parse(holiday.date);
    final isWeekend = holidayDate.weekday == DateTime.saturday || holidayDate.weekday == DateTime.sunday;
    final fontSize = getResponsiveFontSize(context);
    final containerSize = getResponsiveFontSize(context, small: 45, medium: 50, large: 55);
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 6 : 8),
      child: isSmallScreen
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: containerSize,
                      height: containerSize,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isWeekend
                              ? [AppTheme.errorColor.withOpacity(0.1), AppTheme.errorColor.withOpacity(0.05)]
                              : [AppTheme.accentColor.withOpacity(0.1), AppTheme.accentColor.withOpacity(0.05)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isWeekend ? AppTheme.errorColor.withOpacity(0.3) : AppTheme.accentColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('d').format(holidayDate),
                              style: TextStyle(
                                fontSize: fontSize * 1.2,
                                fontWeight: FontWeight.bold,
                                color: isWeekend ? AppTheme.errorColor : AppTheme.accentColor,
                              ),
                            ),
                            Text(
                              DateFormat('MMM').format(holidayDate),
                              style: TextStyle(
                                fontSize: fontSize * 0.7,
                                color: isWeekend ? AppTheme.errorColor : AppTheme.accentColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            holiday.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: fontSize,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(isWeekend ? Icons.weekend : Icons.celebration, size: fontSize * 0.7, color: AppTheme.textSecondary),
                              SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '${holiday.day}, ${DateFormat('MMM d, yyyy').format(holidayDate)}',
                                  style: TextStyle(
                                    fontSize: fontSize * 0.75,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppTheme.accentColor.withOpacity(0.1), AppTheme.primaryColor.withOpacity(0.05)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.accentColor.withOpacity(0.3), width: 0.5),
                      ),
                      child: Text(
                        holiday.type,
                        style: TextStyle(
                          fontSize: fontSize * 0.7,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.accentColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Row(
              children: [
                Container(
                  width: containerSize,
                  height: containerSize,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isWeekend
                          ? [AppTheme.errorColor.withOpacity(0.1), AppTheme.errorColor.withOpacity(0.05)]
                          : [AppTheme.accentColor.withOpacity(0.1), AppTheme.accentColor.withOpacity(0.05)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isWeekend ? AppTheme.errorColor.withOpacity(0.3) : AppTheme.accentColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('d').format(holidayDate),
                          style: TextStyle(
                            fontSize: fontSize * 1.3,
                            fontWeight: FontWeight.bold,
                            color: isWeekend ? AppTheme.errorColor : AppTheme.accentColor,
                          ),
                        ),
                        Text(
                          DateFormat('MMM').format(holidayDate),
                          style: TextStyle(
                            fontSize: fontSize * 0.7,
                            color: isWeekend ? AppTheme.errorColor : AppTheme.accentColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        holiday.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: fontSize,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(isWeekend ? Icons.weekend : Icons.celebration, size: fontSize * 0.8, color: AppTheme.textSecondary),
                          SizedBox(width: 4),
                          Text(
                            '${holiday.day}, ${DateFormat('MMM d, yyyy').format(holidayDate)}',
                            style: TextStyle(
                              fontSize: fontSize * 0.85,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.accentColor.withOpacity(0.1), AppTheme.primaryColor.withOpacity(0.05)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.accentColor.withOpacity(0.3), width: 0.5),
                  ),
                  child: Text(
                    holiday.type,
                    style: TextStyle(
                      fontSize: fontSize * 0.8,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.accentColor,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM d, yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }
}