import 'package:flutter/material.dart';
import 'package:shishughar/utils/globle_method.dart';
import '../model/databasemodel/child_growth_responce_model.dart';
import '../style/styles.dart';


class YearMonthCalendar extends StatefulWidget {
  final DateTime initialDate;
  final List<ChildGrowthMetaResponseModel> mesures;
  final Function(String?) onTap;

  YearMonthCalendar({
    required this.initialDate,
    required this.mesures,
    required this.onTap,
  });

  @override
  _CustomCalendarState createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<YearMonthCalendar> {
  late DateTime _currentDate;
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
  }

  void _changeYear(int step) {
    setState(() {
      _currentDate = DateTime(_currentDate.year+step,1, 1);
    });
  }
  void _selectYear(int year) {
    setState(() {
      _currentDate = DateTime(year, _currentDate.month, 1);
      _showYearGrid = false;
    });

  }



  List<Widget> _buildMonthGrid() {
    return List.generate(12, (index) {
      DateTime today = DateTime.now();
      String? selectGuid = null;
      DateTime date=DateTime(_currentDate.year,index+1);
      bool isFuture = date.isAfter(today);
      var attendeDateEs= widget.mesures.where((item) {
        var attendenceDate = Global.stringToDate(item.measurement_date);
        if (attendenceDate != null) {
          return (attendenceDate.year == date.year &&
              attendenceDate.month == date.month && item.is_uploaded==1);
        }else return false;
      }).toList();

      bool isAttendece=attendeDateEs.isNotEmpty?true:false;
      selectGuid=attendeDateEs.isNotEmpty?attendeDateEs.first.cgmguid:null;

      bool isAttendeceDraft=false;
      if(!Global.validString(selectGuid)){
        var attendeDateDraft= widget.mesures.where((item) {
          var attendenceDate = Global.stringToDate(item.measurement_date);
          if (attendenceDate != null) {
            return (attendenceDate.year == date.year &&
                attendenceDate.month == date.month && item.is_uploaded==0);
          }else return false;
        }).toList();

         isAttendeceDraft=attendeDateDraft.isNotEmpty?true:false;
        selectGuid=attendeDateDraft.isNotEmpty?attendeDateDraft.first.cgmguid:null;
      }




      return GestureDetector(
        onTap: () => widget.onTap(selectGuid),
        child: Container(
          height: 20,
          margin: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color:isAttendece
                ? Colors.green:isAttendeceDraft?Colors.red
                : (isFuture ? Colors.grey[300] : Colors.white),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey, width: 0.5),
          ),
          alignment: Alignment.center,
          child: Text(
            months[index],
            style: TextStyle(
              color: isAttendece
            ? Colors.white :isAttendeceDraft?Colors.white
                : (isFuture ? Colors.grey : Colors.black),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                _showYearGrid
                    ? 'Select Year'
                    : '',
                style: Styles.blue148,
              ),
            ),
            // IconButton(
            //     onPressed: () {
            //       setState(() {
            //         _showYearGrid = !_showYearGrid;
            //       });
            //     },
            //     icon: Icon(Icons.calendar_month))
          ],
        ),
        _showYearGrid?SizedBox(): Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios_sharp),
              onPressed: () => _changeYear(-1),
            ),
            Text(
              "${_currentDate.year}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios_sharp),
              onPressed: () => _changeYear(1),
            ),
          ],
        ),
        SizedBox(height: 10,),
        // Month Grid (Shown when Month Button is clicked)
        if (_showYearGrid)
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
        else Expanded(
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
      ],
    );
  }
}