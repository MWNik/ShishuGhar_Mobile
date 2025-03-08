import 'package:flutter/material.dart';
import 'package:shishughar/utils/globle_method.dart';

import '../model/databasemodel/child_attendance_responce_model.dart';
import '../style/styles.dart';

class CustomCalendar extends StatefulWidget {
  final DateTime initialDate;
  final List<ChildAttendanceResponceModel> attendece;
  final Function(String?) onTap;

  CustomCalendar({
    required this.initialDate,
    required this.attendece,
    required this.onTap,
  });

  @override
  _CustomCalendarState createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  late DateTime _currentDate;
  DateTime? _selectedDate;
  bool _showMonthGrid = false;
  bool _showYearGrid = false;
  int startYear = 2000;

  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  void initState() {
    super.initState();
    _currentDate = widget.initialDate;
    _selectedDate = _currentDate;
  }

  DateTime get _firstDayOfMonth =>
      DateTime(_currentDate.year, _currentDate.month, 1);

  DateTime get _lastDayOfMonth =>
      DateTime(_currentDate.year, _currentDate.month + 1, 0);

  void _changeMonth(int step) {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month + step, 1);
    });
  }

  void _selectMonth(int monthIndex) {
    setState(() {
      _currentDate = DateTime(_currentDate.year, monthIndex + 1, 1);
      _showMonthGrid = false; // Hide month grid after selection
    });
  }

  void _selectYear(int year) {
    setState(() {
      _currentDate = DateTime(year, _currentDate.month, 1);
      _showYearGrid = false;
      _showMonthGrid = true;
    });
  }

  Widget _buildDayItem(DateTime date) {
    DateTime today = DateTime.now();
    String? selectGuid = null;
    bool isFuture = date.isAfter(today);
    bool isToday = date.day == today.day &&
        date.month == today.month &&
        date.year == today.year;
    bool isSelected = _selectedDate != null &&
        date.day == _selectedDate!.day &&
        date.month == _selectedDate!.month &&
        date.year == _selectedDate!.year;

   var attendeDateEs= widget.attendece.where((item) {
      var attendenceDate = Global.stringToDate(item.date_of_attendance);
      if (attendenceDate != null) {
        return (attendenceDate.year == date.year &&
            attendenceDate.month == date.month &&
            attendenceDate.day == date.day && item.is_edited==0 && item.is_uploaded==1);
      }else return false;
    }).toList();

    var attendeDateEsDarft= widget.attendece.where((item) {
      var attendenceDate = Global.stringToDate(item.date_of_attendance);
      if (attendenceDate != null) {
        return (attendenceDate.year == date.year &&
            attendenceDate.month == date.month &&
            attendenceDate.day == date.day && item.is_edited!=0);
      }else return false;
    }).toList();

   bool isAttendece=attendeDateEs.isNotEmpty?true:false;
   selectGuid=attendeDateEs.isNotEmpty?attendeDateEs.first.childattenguid:null;
   bool isAttendeceDarft=false;
   if(!Global.validString(selectGuid)){
       isAttendeceDarft=attendeDateEsDarft.isNotEmpty?true:false;
      selectGuid=attendeDateEsDarft.isNotEmpty?attendeDateEsDarft.first.childattenguid:null;
    }

    return GestureDetector(
      onTap: isFuture
          ? null
          : () {
        widget.onTap(selectGuid);
              // setState(() {
              //   _selectedDate = date;
              // });
              // Navigator.of(context).pop(date);
            },
      child: Container(
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          // color: isSelected
          color: isAttendece
              ? Colors.green
              : (isAttendeceDarft ?Colors.red : (isFuture ? Colors.grey[300] : Colors.white)),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey, width: 0.5),
        ),
        alignment: Alignment.center,
        child: Text(
          date.day.toString(),
          style: TextStyle(
            // color: isSelected
            color: isAttendece
                ? Colors.white
                : (isAttendeceDarft ? Colors.white
                    : (isFuture ? Colors.grey : Colors.black)),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCalendarGrid() {
    List<Widget> dayItems = [];
    int daysInMonth = _lastDayOfMonth.day;
    int firstWeekdayOfMonth = _firstDayOfMonth.weekday;

    for (int i = 1; i < firstWeekdayOfMonth; i++) {
      dayItems.add(Container());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      dayItems.add(
          _buildDayItem(DateTime(_currentDate.year, _currentDate.month, day)));
    }

    return dayItems;
  }

  List<Widget> _buildMonthGrid() {
    return List.generate(12, (index) {
      return GestureDetector(
        onTap: () => _selectMonth(index),
        child: Container(
          height: 20,
          margin: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color:
                _currentDate.month == index + 1 ? Colors.green : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey, width: 0.5),
          ),
          alignment: Alignment.center,
          child: Text(
            months[index],
            style: TextStyle(
              color:
                  _currentDate.month == index + 1 ? Colors.white : Colors.black,
            ),
          ),
        ),
      );
    });
  }

  List<Widget> _buildYearGrid() {
    return List.generate((DateTime.now().year - startYear + 1), (index) {
      int year = startYear + index;
      return GestureDetector(
        onTap: () => _selectYear(year),
        child: Container(
          margin: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: _currentDate.year == year ? Colors.green : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey, width: 0.5),
          ),
          alignment: Alignment.center,
          child: Text(
            year.toString(),
            style: TextStyle(
              color: _currentDate.year == year ? Colors.white : Colors.black,
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Top Row with Arrows and Month Selection Button
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Padding(
        //       padding: EdgeInsets.only(left: 15),
        //       child: Text(
        //         _showYearGrid
        //             ? 'Select Year'
        //             : _showMonthGrid
        //                 ? 'Select month'
        //                 : 'Attendance Status',
        //         style: Styles.blue148,
        //       ),
        //     ),
        //     IconButton(
        //         onPressed: () {
        //           setState(() {
        //             _showYearGrid = !_showYearGrid;
        //             _showMonthGrid = false;
        //           });
        //         },
        //         icon: Icon(Icons.calendar_month))
        //     // TextButton(
        //     //   onPressed: () {
        //     //     setState(() {
        //     //       _showYearGrid = !_showYearGrid;
        //     //       _showMonthGrid = false;
        //     //     });
        //     //   },
        //     //   child: Text("Year",
        //     //       style: TextStyle(fontSize: 16, color: Colors.blue)),
        //     // ),
        //     // TextButton(
        //     //   onPressed: () {
        //     //     setState(() {
        //     //       _showMonthGrid = !_showMonthGrid; // Toggle month grid
        //     //       _showYearGrid = false;
        //     //     });
        //     //   },
        //     //   child: Text(
        //     //     "Month",
        //     //     style: TextStyle(fontSize: 16, color: Colors.blue),
        //     //   ),
        //     // ),
        //   ],
        // ),
        (_showYearGrid == false && _showMonthGrid == false)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_sharp),
                    onPressed: () => _changeMonth(-1),
                  ),
                  Text(
                    "${months[_currentDate.month - 1]} ${_currentDate.year}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios_sharp),
                    onPressed: () => _changeMonth(1),
                  ),
                ],
              )
            : SizedBox(),

        // Month Grid (Shown when Month Button is clicked)
        if (_showMonthGrid)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 4),
                children: _buildMonthGrid(),
              ),
            ),
          )
        else if (_showYearGrid)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: GridView.count(
                crossAxisCount: 4,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 4),
                children: _buildYearGrid(),
              ),
            ),
          )
        else ...[
          // Days of the Week Header
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const <Widget>[
                Text('Mon'),
                Text('Tue'),
                Text('Wed'),
                Text('Thu'),
                Text('Fri'),
                Text('Sat'),
                Text('Sun'),
              ],
            ),
          ),

          // Calendar Grid
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: GridView.count(
                crossAxisCount: 7,
                children: _buildCalendarGrid(),
              ),
            ),
          ),
            Row(

            )
        ],
      ],
    );
  }
}
