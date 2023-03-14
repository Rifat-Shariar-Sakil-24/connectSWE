library calendar;

import 'dart:math';

import 'package:connectswe/ui/auth/login_screen.dart';
import 'package:connectswe/ui/auth/login_screen_main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

import '../utils/utils.dart';

part 'appointment_editor.dart';

part 'color_picker.dart';
part 'course_picker.dart';

class PostScreen2 extends StatefulWidget {
  const PostScreen2({Key? key}) : super(key: key);

  @override
  State<PostScreen2> createState() => _PostScreenState2();
}

String _subjectText = '',
    _startTimeText = '',
    _endTimeText = '',
    _dateText = '',
    _timeDetails = '';

List<Color> _colorCollection = <Color>[];
List<String> _colorNames = <String>[];
List<String> eventNameCollection = <String>[];
int _selectedColorIndex = 0;
int _selectedTimeZoneIndex = 0;
int eventNameIndex = 0;
List<String> _timeZoneCollection = <String>[];
late MeetingDataSource _events;
Meeting? _selectedAppointment;
late DateTime _startDate;
late TimeOfDay _startTime;
late DateTime _endDate;
late TimeOfDay _endTime;
bool _isAllDay = false;
String _subject = '';
//String _notes = '';
//String _recurrenceRule = '';

class _PostScreenState2 extends State<PostScreen2> {

  _PostScreenState2();

  //late List<String> eventNameCollection;
  late List <Meeting> appointments;
  CalendarController calendarController = CalendarController();


  //late List<Appointment> _courses;
  //late List<CalendarResource> _courseTeachers;

  //late MeetingDataSource _events;
  //late List<Appointment> _courses;
  //late List<CalendarResource> _courseTeachers;
  late List<TimeRegion> _specialTimeRegion;

  @override
  void initState() {
    appointments = getMeetingDetails();
    addSpecialRegion();
    _events = MeetingDataSource(appointments);
    _selectedAppointment = null;

    _selectedColorIndex = 0;
    //_selectedTimeZoneIndex = 0;

    _subject = '';
    //_notes = '';
    //_recurrenceRule = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Calendar'),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          // elevation: ,
        ),

        body: getEventCalendar(_events, onCalendarTapped)
    );
  }

  SfCalendar getEventCalendar(CalendarDataSource _calendarDataSource,
      CalendarTapCallback calendarTapCallback){

    return SfCalendar(

      view: CalendarView.week,
      dataSource: _calendarDataSource,
      specialRegions: _specialTimeRegion,

      onTap: calendarTapCallback,
      //allowedViews: const [CalendarView.week, CalendarView.timelineWeek],
      controller: calendarController,

      timeSlotViewSettings: TimeSlotViewSettings(
          startHour: 9, endHour: 17, timeFormat: 'h:mm',
          timeInterval: Duration(minutes: 30,)),
      todayHighlightColor: Colors.green[500],

      appointmentBuilder: (context, details){
        final Meeting meeting = details.appointments.first;
        return Container(
          color: meeting.background,
          child: Text(meeting.eventName,
          style: TextStyle(
            color: Colors.white,
            shadows: <Shadow>[
              Shadow(
                //offset: Offset(10.0, 10.0),
                blurRadius: 5.0,
                //color: Color.fromARGB(255, 0, 0, 0),
                color: Colors.black87
              ),
            ],
            fontSize: 13.5,
            fontWeight: FontWeight.bold,
          ),),
        );

      },
    );

  }

  void onCalendarTapped(CalendarTapDetails details) {

    if (details.targetElement != CalendarElement.calendarCell &&
        details.targetElement != CalendarElement.appointment) {
      return;
    }

    setState(() {
      _selectedAppointment = null;
      _isAllDay = false;
      //_selectedColorIndex = 0;
      //_selectedTimeZoneIndex = 0;
      _subject = '';
      //_notes = '';
      //_recurrenceRule = '';

      if (details.appointments != null &&
            details.appointments!.length == 1) {
          final Meeting meetingDetails = details.appointments![0];
          _startDate = meetingDetails.from;
          _endDate = meetingDetails.to;
          _isAllDay = meetingDetails.isAllDay;
          _subject = meetingDetails.eventName == '(No Title)' ?
          '' : meetingDetails.eventName;
          _selectedColorIndex =
              _colorCollection.indexOf(meetingDetails.background);
          //_notes = meetingDetails.description;
          _selectedAppointment = meetingDetails;
          //_recurrenceRule = _recurrenceRule;
        }

        else {
          final DateTime date = details.date!;
          _startDate = date;
          _endDate = date.add(const Duration(hours: 1));
        }
        _startTime =
            TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
        _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
        Navigator.push<Widget>(
          context,
          MaterialPageRoute(builder:
              (BuildContext context) => AppointmentEditor()),);
      }
    );
  }

  void addSpecialRegion() {
    final DateTime date = DateTime(2023, 2, 12, 8, 0, 0);
    _specialTimeRegion = [
      TimeRegion(startTime: DateTime(2023, 1, 8, 13, 0, 0),
          endTime: DateTime(2023, 1, 8, 14, 0, 0),
          text: 'LUNCH',
          recurrenceRule: 'FREQ=DAILY,INTERVAL=1',
          enablePointerInteraction: false)
    ];

  }

  List <Meeting> getMeetingDetails(){
    final List <Meeting> meetingCollection = <Meeting>[];

    eventNameCollection = <String>['SWE 221', 'SWE 222', 'SWE 223', 'SWE 331'];
    //eventNameCollection.add('SWE 331');

    _colorCollection = <Color> [Colors.red, Colors.blue, Colors.green, Colors.yellow];

    _colorNames = <String>['Red', 'Blue', 'Green', 'Yellow'];

    final DateTime today =  DateTime(2023,1,8);
    final DateTime finalDate = DateTime(2023,7,10);
    final Random random = Random();

    for (int month = 0; month < 5; month++) {
      for (int day = 0; day < 30; day++) {

        //monday - done
        if(today.add(Duration(days: (month*30) + day)).weekday == 1){
          meetingCollection.add(Meeting(
            from: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 9)),
            to: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 10, minutes: 30)),
            background: _colorCollection[0],
            //startTimeZone: '',
            //endTimeZone: '',
            //description: '',
            isAllDay: false,
            eventName: eventNameCollection[0],
            //recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;COUNT=10',
          ));

          meetingCollection.add(Meeting(
            from: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 11)),
            to: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 13)),
            background: _colorCollection[2],
            //startTimeZone: '',
            //endTimeZone: '',
            //description: '',
            isAllDay: false,
            eventName: eventNameCollection[2],
            //recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;COUNT=10',
          ));

          meetingCollection.add(Meeting(
            from: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 14)),
            to: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 16)),
            background: _colorCollection[3],
            //startTimeZone: '',
            //endTimeZone: '',
            //description: '',
            isAllDay: false,
            eventName: eventNameCollection[3],
            //recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;COUNT=10',
          ));
        }


        //tuesday - done
        if(today.add(Duration(days: (month*30) + day)).weekday == 2){
          meetingCollection.add(Meeting(
            from: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 12)),
            to: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 13)),
            background: _colorCollection[2],
            //startTimeZone: '',
            //endTimeZone: '',
            //description: '',
            isAllDay: false,
            eventName: eventNameCollection[2],
            //recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;COUNT=10',
          ));

          meetingCollection.add(Meeting(
            from: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 14)),
            to: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 15)),
            background: _colorCollection[1],
            //startTimeZone: '',
            //endTimeZone: '',
            //description: '',
            isAllDay: false,
            eventName: eventNameCollection[1],
            //recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;COUNT=10',
          ));

          meetingCollection.add(Meeting(
            from: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 15)),
            to: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 17)),
            background: _colorCollection[0],
            //startTimeZone: '',
            //endTimeZone: '',
            //description: '',
            isAllDay: false,
            eventName: eventNameCollection[0],
            //recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;COUNT=10',
          ));
        }


        //wednesday - done
        if(today.add(Duration(days: (month*30) + day)).weekday == 3){
          meetingCollection.add(Meeting(
            from: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 9)),
            to: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 11)),
            background: _colorCollection[0],
            //startTimeZone: '',
            //endTimeZone: '',
            //description: '',
            isAllDay: false,
            eventName: eventNameCollection[0],
            //recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;COUNT=10',
          ));

          meetingCollection.add(Meeting(
            from: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 14)),
            to: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 17)),
            background: _colorCollection[2],
            //startTimeZone: '',
            //endTimeZone: '',
            //description: '',
            isAllDay: false,
            eventName: eventNameCollection[2],
            //recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;COUNT=10',
          ));

          // meetingCollection.add(Meeting(
          //   from: today
          //       .add(Duration(days: (month * 30) + day))
          //       .add(Duration(hours: 14)),
          //   to: today
          //       .add(Duration(days: (month * 30) + day))
          //       .add(Duration(hours: 16)),
          //   // background: _colorCollection[random.nextInt(9)],
          //   //startTimeZone: '',
          //   //endTimeZone: '',
          //   //description: '',
          //   isAllDay: false,
          //   eventName: eventNameCollection[3],
          //   //recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;COUNT=10',
          // ));
        }


        //thursday - done
        if(today.add(Duration(days: (month*30) + day)).weekday == 4){
          meetingCollection.add(Meeting(
            from: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 10, minutes: 30)),
            to: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 12, minutes: 30)),
            background: _colorCollection[3],
            //startTimeZone: '',
            //endTimeZone: '',
            //description: '',
            isAllDay: false,
            eventName: eventNameCollection[3],
            //recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;COUNT=10',
          ));

          meetingCollection.add(Meeting(
            from: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 14)),
            to: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 15)),
            background: _colorCollection[1],
            //startTimeZone: '',
            //endTimeZone: '',
            //description: '',
            isAllDay: false,
            eventName: eventNameCollection[1],
            //recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;COUNT=10',
          ));

          // meetingCollection.add(Meeting(
          //   from: today
          //       .add(Duration(days: (month * 30) + day))
          //       .add(Duration(hours: 14)),
          //   to: today
          //       .add(Duration(days: (month * 30) + day))
          //       .add(Duration(hours: 16)),
          //   // background: _colorCollection[random.nextInt(9)],
          //   //startTimeZone: '',
          //   //endTimeZone: '',
          //   //description: '',
          //   isAllDay: false,
          //   eventName: eventNameCollection[3],
          //   //recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;COUNT=10',
          // ));
        }


        //sunday - done
        if(today.add(Duration(days: (month*30) + day)).weekday == 7){
          meetingCollection.add(Meeting(
            from: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 10)),
            to: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 11, minutes: 30)),
            background: _colorCollection[1],
            //startTimeZone: '',
            //endTimeZone: '',
            //description: '',
            isAllDay: false,
            eventName: eventNameCollection[1],
            //recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;COUNT=10',
          ));

          meetingCollection.add(Meeting(
            from: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 12)),
            to: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 13)),
            background: _colorCollection[0],
            //startTimeZone: '',
            //endTimeZone: '',
            //description: '',
            isAllDay: false,
            eventName: eventNameCollection[0],
            //recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;COUNT=10',
          ));

          meetingCollection.add(Meeting(
            from: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 15)),
            to: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 16)),
            background: _colorCollection[3],
            //startTimeZone: '',
            //endTimeZone: '',
            //description: '',
            isAllDay: false,
            eventName: eventNameCollection[3],
            //recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;COUNT=10',
          ));
        }

        }}
    return meetingCollection;
  }


}

class MeetingDataSource extends CalendarDataSource{
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  bool isAllDay(int index) => appointments![index].isAllDay;

  @override
  String getSubject(int index) => appointments![index].eventName;

  //@override
  //String getStartTimeZone(int index) => appointments![index].startTimeZone;

  //@override
 // String getNotes(int index) => appointments![index].description;

  //@override
  //String getEndTimeZone(int index) => appointments![index].endTimeZone;

  //@override
  //Color getColor(int index) => appointments![index].background;

  @override
  DateTime getStartTime(int index) => appointments![index].from;

  @override
  DateTime getEndTime(int index) => appointments![index].to;

  //@override
  //String getRecurrenceRule(int index) => appointments![index].recurrenceRule;

}

class Meeting {
  Meeting(
      {required this.from,
        required this.to,
        this.background = Colors.green,
        this.isAllDay = false,
        this.eventName = '',
        //this.startTimeZone = '',
        //this.endTimeZone = '',
        //this.description = '',
        //this.recurrenceRule =''
      });

  final String eventName;
  final DateTime from;
  final DateTime to;
  final Color background;
  final bool isAllDay;
  //final String startTimeZone;
  //final String endTimeZone;
  //final String description;
  //final String? recurrenceRule;

}