library calendar;

import 'dart:math';

import 'package:connectswe/config/palette.dart';
import 'package:connectswe/post/post_screen3.dart';
import 'package:connectswe/ui/auth/login_screen.dart';
import 'package:connectswe/ui/auth/login_screen_main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import '../utils/utils.dart';

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/scheduler.dart';

part 'appointment_editor.dart';
part 'color_picker.dart';
part 'course_picker.dart';
part 'appointment_viewer.dart';

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
List<String> eventNameCollection = <String>[];
List<String> _colorNames = <String>[];
List<String> courseNameCollection = <String>[];
List<String> teacherNameCollection = <String>[];


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
String _notes = '';
String _courseName = '';
String _teacherName = '';
//String _recurrenceRule = '';

class _PostScreenState2 extends State<PostScreen2> {

  final user = FirebaseAuth.instance.currentUser;
  final auth = FirebaseAuth.instance;

  final databaseReference = FirebaseFirestore.instance;
  final databaseReferenceSWE222 = FirebaseFirestore.instance;
  final databaseReferenceMain = FirebaseFirestore.instance;

  _PostScreenState2();

  late List <Meeting> appointments;
  CalendarController calendarController = CalendarController();



  late List<TimeRegion> _specialTimeRegion;

  @override
  void initState() {
    appointments = getMeetingDetails();
    addSpecialRegion();
    _events = MeetingDataSource(appointments);
    _selectedAppointment = null;

    _selectedColorIndex = 0;

    _subject = '';
    _notes = '';
    _courseName = '';
    _teacherName = '';
    //_recurrenceRule = '';

    getDataFromFireStore().then((results) {
      SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    });
    super.initState();
  }

  Future<void> getDataFromFireStore() async {

    var snapShotsValue = await databaseReference
       //.collection("StoreALlCourses")
        .collection("Courses")
        .get();
    var snapshots = await databaseReferenceSWE222
    .collection("SWE 222")
    .get();



  }
  /*Future<DocumentSnapshot> getDocument(String date) async {
    /*DocumentSnapshot documentSnapshot =
    await databaseReferenceSWE222.collection('SWE 222').doc(date).get();
    return documentSnapshot;
    */
    DocumentSnapshot documentSnapshot =
    await databaseReferenceSWE222.collection('SWE 222').doc(date).get();
    return documentSnapshot;
  }*/

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: AppBar(

            automaticallyImplyLeading: false,
            title: Text('connectSWE'),
            centerTitle: true,
            backgroundColor: Palette.backgroundColor2,
            actions: [
              IconButton(onPressed: (){
                auth.signOut().then((value) {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreenMain()));
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
              }, icon: Icon(
                  Icons.logout_outlined
              ),
              ),
              SizedBox(width: 20,)
            ],
            // elevation: ,
          ),
          body: getEventCalendar(_events, onCalendarTapped)
      ),
    );
  }

  SfCalendar getEventCalendar(CalendarDataSource _calendarDataSource,
      CalendarTapCallback calendarTapCallback){

    return SfCalendar(

      //decoration
      //backgroundColor: Colors.grey,
      selectionDecoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.black87, width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        shape: BoxShape.rectangle,
      ),
      headerStyle: const CalendarHeaderStyle(
        backgroundColor: Palette.backgroundColor,
        textStyle: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      //cellBorderColor: Colors.blue[100],


      view: CalendarView.week,
      dataSource: _calendarDataSource,
      specialRegions: _specialTimeRegion,

      onTap: calendarTapCallback,
      //allowedViews: const [CalendarView.week, CalendarView.timelineWeek],
      controller: calendarController,

      timeSlotViewSettings: TimeSlotViewSettings(
          startHour: 9, endHour: 17, timeFormat: 'h:mm',
          timeInterval: Duration(minutes: 30,)),
      todayHighlightColor: Palette.backgroundColor2,
      todayTextStyle: TextStyle(),

      appointmentBuilder: (context, details){
        final Meeting meeting = details.appointments.first;
        return Container(
          color: meeting.background,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(meeting.eventName,
            style: const TextStyle(
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
          ),
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
      _notes = '';
      _courseName = '';
      _teacherName = '';
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
          _notes = meetingDetails.description;
          _courseName = meetingDetails.courseName;
          _teacherName = meetingDetails.teacherName;
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

      final user = this.user;
      String gg="";
      if (user != null) {
        gg += user.email.toString();

      }
      String email1 = gg;
      String email2 = "rifat24@student.sust.edu";
      String email3 = "shahriar33@student.sust.edu";

        if(email1==email2 || email1==email3) {
          Navigator.push<Widget>(
          context,
          MaterialPageRoute(builder:
              (BuildContext context) => AppointmentEditor()),);}
        else {
          Navigator.push<Widget>(
            context,
            MaterialPageRoute(builder:
            (BuildContext context) => AppointmentViewer()),);}
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

    eventNameCollection = <String>['SWE 222', 'SWE 223', 'SWE 227', 'SWE 229'];

    _colorCollection = <Color> [Colors.red, Colors.blue, Colors.green, Colors.deepPurple];

    _colorNames = <String>['Red', 'Blue', 'Green', 'Purple'];

    courseNameCollection = <String>[
      'Introduction to Competitive Programming',
      'Object Oriented Programming',
      'Theory of Computation',
      'Algorithm Design and Analysis'];

    teacherNameCollection = <String>[
      'Partha Protim Paul',
      'Asif Mohammed Samir',
      'Raihan Ullah',
      'Partha Protim Paul'];

    final DateTime today =  DateTime(2023,1,8);
    final DateTime finalDate = DateTime(2023,7,10);
    final Random random = Random();

    for (int month = 0; month < 5; month++) {
      for (int day = 0; day < 30; day++) {



        String dateStr = today.add(Duration(days: (month*30) + day)).toString();
     //   print(dateStr);
        //monday - done
        if(today.add(Duration(days: (month*30) + day)).weekday == 1){

       //   setDefaultRoutine(eventNameCollection[0], dateStr, 9, 0, 10, 30);

         /* databaseReferenceSWE222.collection("SWE 222").doc(dateStr).set({
            'beginH': 9,
            'beginM':0,
            'endH': 10,
            'endM': 30
          });*/


      // String documentSnapshot =       databaseReference.collection("StoreAllCourses").doc(eventNameCollection[0]).collection("Dates").doc(dateStr).collection("Start").doc("starttime").collection("Hours").
      //    doc("hours").path.toString();

        //  print(documentSnapshot);

          num SH, SM, EH, EM;
          String course = eventNameCollection[0];

          FirebaseFirestore.instance
              .collection('Courses')
              .doc(course)
              .collection(dateStr)
              .doc('Info')
              .get()
              .then((DocumentSnapshot documentSnapshot) {

              print('ashche');
              SH = documentSnapshot.get('beginH');
              SM = documentSnapshot.get('beginM');
              EH = documentSnapshot.get('endH');
              EM = documentSnapshot.get('endM');

          });


      //setDefaultRoutineMain(eventNameCollection[0], dateStr, 9, 0, 10, 30);

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
            description: '',
            isAllDay: false,
            eventName: eventNameCollection[0],
            courseName: courseNameCollection[0],
            teacherName: teacherNameCollection[0],
            //recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;COUNT=10',
          ));



         // setDefaultRoutine(eventNameCollection[2], dateStr, 11, 0, 13, 0);
          setDefaultRoutineMain(eventNameCollection[2], dateStr, 11, 0, 13, 0);


          meetingCollection.add(Meeting(
            from: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 11)),
            to: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 13)),
            background: _colorCollection[2],
            description: '',
            isAllDay: false,
            eventName: eventNameCollection[2],
            courseName: courseNameCollection[2],
            teacherName: teacherNameCollection[2],
            //recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;COUNT=10',
          ));

          //setDefaultRoutine(eventNameCollection[3], dateStr, 14, 0, 16, 0);
          setDefaultRoutineMain(eventNameCollection[3], dateStr, 14, 0, 16, 0);

          meetingCollection.add(Meeting(
            from: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 14)),
            to: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 16)),
            background: _colorCollection[3],
            description: '',
            isAllDay: false,
            eventName: eventNameCollection[3],
            courseName: courseNameCollection[3],
            teacherName: teacherNameCollection[3],
            //recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;COUNT=10',
          ));

        }


        //tuesday - done
        if(today.add(Duration(days: (month*30) + day)).weekday == 2){

          //setDefaultRoutine(eventNameCollection[2], dateStr, 12, 0, 13, 0);
          setDefaultRoutineMain(eventNameCollection[2], dateStr, 12, 0, 13, 0);

          meetingCollection.add(Meeting(
            from: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 12)),
            to: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 13)),
            background: _colorCollection[2],
            description: '',
            isAllDay: false,
            eventName: eventNameCollection[2],
            courseName: courseNameCollection[2],
            teacherName: teacherNameCollection[2],
            //recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;COUNT=10',
          ));


          //setDefaultRoutine(eventNameCollection[1], dateStr, 14, 0, 15, 0);
          setDefaultRoutineMain(eventNameCollection[1], dateStr, 14, 0, 15, 0);
          meetingCollection.add(Meeting(
            from: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 14)),
            to: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 15)),
            background: _colorCollection[1],
            description: '',
            isAllDay: false,
            eventName: eventNameCollection[1],
            courseName: courseNameCollection[1],
            teacherName: teacherNameCollection[1],
            //recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;COUNT=10',
          ));




          //setDefaultRoutine(eventNameCollection[0], dateStr, 15, 0, 17, 0);
          setDefaultRoutineMain(eventNameCollection[0], dateStr, 15, 0, 17, 0);

          meetingCollection.add(Meeting(
            from: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 15)),
            to: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 17)),
            background: _colorCollection[0],
            description: '',
            isAllDay: false,
            eventName: eventNameCollection[0],
            courseName: courseNameCollection[0],
            teacherName: teacherNameCollection[0],
            //recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;COUNT=10',
          ));
        }


        //wednesday - done
        if(today.add(Duration(days: (month*30) + day)).weekday == 3){


          //setDefaultRoutine(eventNameCollection[0], dateStr, 9, 0, 11, 0);
          setDefaultRoutineMain(eventNameCollection[0], dateStr, 9, 0, 11, 0);


          meetingCollection.add(Meeting(
            from: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 9)),
            to: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 11)),
            background: _colorCollection[0],
            description: '',
            isAllDay: false,
            eventName: eventNameCollection[0],
            courseName: courseNameCollection[0],
            teacherName: teacherNameCollection[0],
            //recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;COUNT=10',
          ));



          //setDefaultRoutine(eventNameCollection[2], dateStr, 14, 0, 17, 0);
          setDefaultRoutineMain(eventNameCollection[2], dateStr, 14, 0, 17, 0);

          meetingCollection.add(Meeting(
            from: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 14)),
            to: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 17)),
            background: _colorCollection[2],
            description: '',
            isAllDay: false,
            eventName: eventNameCollection[2],
            courseName: courseNameCollection[2],
            teacherName: teacherNameCollection[2],
            //recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;COUNT=10',
          ));
        }


        //thursday - done
        if(today.add(Duration(days: (month*30) + day)).weekday == 4){

          //setDefaultRoutine(eventNameCollection[3], dateStr, 10, 30, 12, 30);
          setDefaultRoutineMain(eventNameCollection[3], dateStr, 10, 30, 12, 30);

          meetingCollection.add(Meeting(
            from: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 10, minutes: 30)),
            to: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 12, minutes: 30)),
            background: _colorCollection[3],
            description: '',
            isAllDay: false,
            eventName: eventNameCollection[3],
            courseName: courseNameCollection[3],
            teacherName: teacherNameCollection[3],
            //recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;COUNT=10',
          ));


          //setDefaultRoutine(eventNameCollection[1], dateStr, 14, 0, 15, 0);
          setDefaultRoutineMain(eventNameCollection[1], dateStr, 14, 0, 15, 0);

          meetingCollection.add(Meeting(
            from: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 14)),
            to: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 15)),
            background: _colorCollection[1],
            description: '',
            isAllDay: false,
            eventName: eventNameCollection[1],
            courseName: courseNameCollection[1],
            teacherName: teacherNameCollection[1],
            //recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;COUNT=10',
          ));
        }


        //sunday - done
        if(today.add(Duration(days: (month*30) + day)).weekday == 7){
          //setDefaultRoutine(eventNameCollection[1], dateStr, 10, 0, 11, 30);
          setDefaultRoutineMain(eventNameCollection[1], dateStr, 10, 0, 11, 30);

          meetingCollection.add(Meeting(
            from: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 10)),
            to: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 11, minutes: 30)),
            background: _colorCollection[1],
            description: '',
            isAllDay: false,
            eventName: eventNameCollection[1],
            courseName: courseNameCollection[1],
            teacherName: teacherNameCollection[1],
            //recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;COUNT=10',
          ));


          //setDefaultRoutine(eventNameCollection[0], dateStr, 12, 0, 13, 0);
          setDefaultRoutineMain(eventNameCollection[0], dateStr, 12, 0, 13, 0);

          meetingCollection.add(Meeting(
            from: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 12)),
            to: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 13)),
            background: _colorCollection[0],
            description: '',
            isAllDay: false,
            eventName: eventNameCollection[0],
            courseName: courseNameCollection[0],
            teacherName: teacherNameCollection[0],
            //recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;COUNT=10',
          ));




          //setDefaultRoutine(eventNameCollection[3], dateStr, 15, 0, 16, 0);
          setDefaultRoutineMain(eventNameCollection[3], dateStr, 15, 0, 16, 0);

          meetingCollection.add(Meeting(
            from: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 15)),
            to: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: 16)),
            background: _colorCollection[3],
            description: '',
            isAllDay: false,
            eventName: eventNameCollection[3],
            courseName: courseNameCollection[3],
            teacherName: teacherNameCollection[3],
            //recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;COUNT=10',
          ));
        }

        }}
    return meetingCollection;
  }

  void setDefaultRoutine(String eInd, String  dateString, int SH, int SM, int EH, int EM) {

    databaseReference.collection("StoreAllCourses").doc(eInd).collection("Dates").doc(dateString).collection("Start").doc("starttime").collection("Hours").doc("hours").
    set({
      'h': SH
    }
    );


    databaseReference.collection("StoreAllCourses").doc(eInd).collection("Dates").doc(dateString).collection("Start").doc("starttime").collection("Minutes").doc("minutes").
    set({
      'm': SM
    }
    );


    databaseReference.collection("StoreAllCourses").doc(eInd).collection("Dates").doc(dateString).collection("End").doc("endtime").collection("Hours").doc("hours").
    set({
      'h': EH
    }
    );

    databaseReference.collection("StoreAllCourses").doc(eInd).collection("Dates").doc(dateString).collection("End").doc("endtime").collection("Minutes").doc("minutes").
    set({
      'h': EM
    }
    );


    //
    databaseReference.collection("StoreAllCourses").doc("SWE 222").collection("Color").doc("bgcolor").set(
      {
        'index' : 0
      }
    );
    databaseReference.collection("StoreAllCourses").doc("SWE 223").collection("Color").doc("bgcolor").set(
        {
          'index' : 1
        }
    );
    databaseReference.collection("StoreAllCourses").doc("SWE 227").collection("Color").doc("bgcolor").set(
        {
          'index' : 2
        }
    );
    databaseReference.collection("StoreAllCourses").doc("SWE 229").collection("Color").doc("bgcolor").set(
        {
          'index' : 3
        }
    );

  }

  void setDefaultRoutineMain(String eInd, String  dateString, int SH, int SM, int EH, int EM) {
    databaseReferenceMain.collection("Courses").doc(eInd).collection(dateString).doc('Info').set({
      'beginH': SH,
      'beginM': SM,
      'endH': EH,
      'endM': EM
    }
    );

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

  String getCourse(int index) => appointments![index].courseName;

  String getTeacher(int index) => appointments![index].teacherName;

  @override
  String getNotes(int index) => appointments![index].description;

  @override
  Color getColor(int index) => appointments![index].background;

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
        this.courseName='',
        this.description = '',
        this.teacherName = '',
        //this.recurrenceRule =''
      });

  final String eventName;
  final String courseName;
  final DateTime from;
  final DateTime to;
  final Color background;
  final bool isAllDay;
  final String description;
  final String teacherName;
  //final String? recurrenceRule;

}