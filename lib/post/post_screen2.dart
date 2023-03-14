library calendar;

import 'dart:math';

import 'package:connectswe/ui/auth/login_screen.dart';
import 'package:connectswe/ui/auth/login_screen_main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

import '../utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
part 'appointment_editor.dart';

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
int _selectedColorIndex = 0;
int _selectedTimeZoneIndex = 0;
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
  final user = FirebaseAuth.instance.currentUser;

  _PostScreenState2();

  late List<String> eventNameCollection;
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

    //_selectedColorIndex = 0;
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
          startHour: 8, endHour: 17, timeFormat: 'h:mm',
          timeInterval: Duration(minutes: 30,)),
      todayHighlightColor: Colors.green[500],

      appointmentBuilder: (context, details){
        final Meeting meeting = details.appointments.first;
        return Container(
          color: Colors.redAccent,
          child: Text(meeting.eventName,
          style: TextStyle(
            color: Colors.white,
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

      //   if (details.targetElement == CalendarElement.appointment ||
      //       details.targetElement == CalendarElement.agenda) {
      //     final Appointment appointmentDetails = details.appointments![0];
      //     _subjectText = appointmentDetails.subject;
      //
      //     _dateText = DateFormat('MMMM dd, yyyy').
      //     format(appointmentDetails.startTime).toString();
      //
      //     _startTimeText = DateFormat('hh:mm a').
      //     format(appointmentDetails.startTime).toString();
      //     _endTimeText = DateFormat('hh:mm a').
      //     format(appointmentDetails.endTime).toString();
      //
      //     _startDate = appointmentDetails.startTime;
      //     _endDate = appointmentDetails.endTime;
      //     _isAllDay = appointmentDetails.isAllDay;
      //
      //     if (appointmentDetails.isAllDay) {
      //       _timeDetails = 'All Day';
      //     } else {
      //       _timeDetails = '$_startTimeText - $_endTimeText';
      //     }
      //
      //     showDialog(
      //         context: context,
      //         builder: (BuildContext context) {
      //           return AlertDialog(
      //             title: Container(
      //               child: Text('$_subjectText'),
      //             ),
      //             content: Container(
      //                 height: 70,
      //                 child: Column(
      //                   children: [
      //                     Row(
      //                       children: [
      //                         Text('$_dateText'),
      //                       ],
      //                     ),
      //                     Row(
      //                       children: [
      //                         Text(' '),
      //                       ],
      //                     ),
      //                     Row(
      //                       children: [
      //                         // Text('$_startTimeText'),
      //                         // Text(' - '),
      //                         // Text('$_endTimeText'),
      //                         Text(_timeDetails!,
      //                             style: TextStyle(
      //                               fontWeight: FontWeight.w400,
      //                               fontSize: 20,
      //                             )),
      //                       ],
      //                     )
      //                   ],
      //                 )
      //             ),
      //             actions: [
      //               new TextButton(
      //                   onPressed: () {
      //                     Navigator.of(context).pop();
      //                   },
      //                   child: new Text('close')),
      //               TextButton(
      //                 onPressed: () {
      //                   showDialog(context: context,
      //                       builder: (BuildContext context) {
      //                         return AppointmentEditor();
      //                       });
      //                 },
      //                 child: new Text('edit'),)
      //             ],
      //           );
      //         });
      //   }
      //
      //   else {
      //     showDialog(
      //         context: context,
      //         builder: (BuildContext context) {
      //           return AlertDialog(
      //             title: Container(
      //               child: Text('No event set'),
      //             ),
      //             content: Container(
      //               height: 70,
      //               child: Text('Set an event'),
      //             ),
      //             actions: [
      //               new TextButton(
      //                   onPressed: () {
      //                     Navigator.of(context).pop();
      //                   },
      //                   child: new Text('close')),
      //               TextButton(
      //                 onPressed: () {
      //                   showDialog(
      //                       context: context,
      //                       builder: (BuildContext context) {
      //                         return AppointmentEditor();
      //                       });
      //                 },
      //                 child: new Text('edit'),)
      //             ],
      //           );
      //         });
      //   }
      // }

    );
  }

  void addSpecialRegion() {
    final DateTime date = DateTime(2023, 2, 12, 8, 0, 0);
    _specialTimeRegion = [
      TimeRegion(startTime: DateTime(2023, 2, 12, 13, 0, 0),
          endTime: DateTime(2023, 2, 12, 14, 0, 0),
          text: 'LUNCH',
          recurrenceRule: 'FREQ=DAILY,INTERVAL=1',
          enablePointerInteraction: false)
    ];

  }

  List <Meeting> getMeetingDetails(){
    final List <Meeting> meetingCollection = <Meeting>[];

    eventNameCollection = <String>['SWE 221', 'SWE 222', 'SWE 223'];
    eventNameCollection.add('SWE 331');

    final DateTime today =  DateTime.now();
    final Random random = Random();

    meetingCollection.add(Meeting(
      from: DateTime(2023,3,12,8,30),
      to: DateTime(2023,3,12,9,30),
      background: Colors.redAccent,
      isAllDay: false,
      //recurrenceRule: 'FREQ=WEEKLY,INTERVAL=1,COUNT=14',
      eventName: eventNameCollection[1],
    ));

    // for (int month = -1; month < 2; month++) {
    //   for (int day = -5; day < 5; day++) {
    //     for (int hour = 9; hour < 18; hour += 5) {
    //       meetingCollection.add(Meeting(
    //         from: today
    //             .add(Duration(days: (month * 30) + day))
    //             .add(Duration(hours: hour)),
    //         to: today
    //             .add(Duration(days: (month * 30) + day))
    //             .add(Duration(hours: hour + 2)),
    //         // background: _colorCollection[random.nextInt(9)],
    //         startTimeZone: '',
    //         endTimeZone: '',
    //         //description: '',
    //         isAllDay: false,
    //         eventName: eventNameCollection[random.nextInt(3)],
    //         recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;COUNT=10',
    //       ));
    //     }}}


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