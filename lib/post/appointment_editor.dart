part of calendar;

class AppointmentEditor extends StatefulWidget{

  const AppointmentEditor({super.key});

  @override
  AppointmentEditorState createState() => AppointmentEditorState();

}

class AppointmentEditorState extends State<AppointmentEditor>{
  Widget _getAppointmentEditor(BuildContext context){
    return Container(
      color: Colors.white,
      child: ListView(
        children: [

          ListTile(
            title: TextField(
              controller: TextEditingController(
                text: _subject,
              ),
              onChanged: (String value){
                _subject = value;
              },
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: const TextStyle(
                fontSize: 25,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Add Title',
              ),
            ),
          ),

          const Divider(
            height: 1.0,
            thickness: 0.5,
          ),


          ListTile(
            leading: const Icon(
              Icons.access_time,
              color: Colors.black87,
            ),
            title: Row(
                children: [
                  Text('All day',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),),
                  Expanded(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Switch(
                            value: _isAllDay,
                            onChanged: (bool value){
                              setState(() {
                                _isAllDay = value;
                              });
                            },
                          )
                      )
                  )
                ]
            ),
          ),

          const Divider(
            height: 1.0,
            thickness: 0.5,
          ),

          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
            leading: const Text(''),
            title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: GestureDetector(
                        child: Text(
                            DateFormat('EEE, MM.dd.yyyy').
                            format(_startDate),
                            textAlign: TextAlign.left),
                        onTap: () async {
                          final DateTime? date = await showDatePicker(
                              context: context,
                              initialDate: _startDate,
                              firstDate: DateTime(1990),
                              lastDate: DateTime(2100)
                          );

                          if(date != null && date != _startDate){
                            setState(() {
                              final Duration difference =
                              _endDate.difference(_startDate);
                              _startDate = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                _startTime.hour,
                                _startTime.minute,
                                0,
                              );
                              _endDate = _startDate.add(difference);
                              _endTime = TimeOfDay(
                                  hour: _endDate.hour,
                                  minute: _endDate.minute);
                            });
                          }

                        },)
                  ),
                  Expanded(
                    //flex: 3,
                    child: _isAllDay
                        ? const Text('')
                        : GestureDetector(
                        child: Text(
                          DateFormat('hh:mm a').format(_startDate),
                          textAlign: TextAlign.right,
                        ),
                        onTap: () async {
                          final TimeOfDay? time =
                          await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(
                                  hour: _startTime.hour,
                                  minute: _startTime.minute));

                          if (time != null && time != _startTime){
                            setState(() {
                              _startTime = time;
                              final Duration difference =
                              _endDate.difference(_startDate);
                              _startDate = DateTime(
                                _startDate.year,
                                _startDate.month,
                                _startDate.day,
                                _startTime.hour,
                                _startTime.minute,
                                0,
                              );

                              _endDate = _startDate.add(difference);
                              _endTime = TimeOfDay(
                                hour: _endDate.hour,
                                minute: _endDate.minute,
                              );
                            });
                          }
                        }),)

                ]
            ),
          ),

          const Divider(
            height: 1.0,
            thickness: 0.5,
          ),

          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
            leading: const Text(''),
            title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: GestureDetector(
                      child: Text(
                        DateFormat('EEE, MM.dd.yyyy').
                        format(_endDate),
                        textAlign: TextAlign.left,
                      ),
                      onTap: () async {
                        final DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: _endDate,
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100));
                        if (date != null && date != _endDate){
                          setState(() {
                            final Duration difference =
                            _endDate.difference(_startDate);
                            _endDate = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              _endTime.hour,
                              _endTime.minute,
                              0,
                            );

                            if(_endDate.isBefore(_startDate)){
                              _startDate = _endDate.subtract(difference);
                              _startTime = TimeOfDay(
                                  hour: _startDate.hour,
                                  minute: _startDate.minute
                              );
                            }

                          });
                        }

                      }
                  )),
                  Expanded(
                      child: _isAllDay
                          ? const Text(''):
                      GestureDetector(
                          child: Text(
                            DateFormat('hh:mm a').
                            format(_endDate),
                            textAlign: TextAlign.right,
                          ),

                          onTap: () async {
                            final TimeOfDay? time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(
                                hour: _endTime.hour,
                                minute: _endTime.minute,
                              ),
                            );

                            if(time != null && time !=_endTime){
                              setState(() {
                                _endTime = time;

                                final Duration difference =
                                _endDate.difference(_startDate);

                                _endDate = DateTime(
                                  _endDate.year,
                                  _endDate.month,
                                  _endDate.day,
                                  _endTime.hour,
                                  _endTime.minute,
                                  0,
                                );

                                if(_endDate.isBefore(_startDate)){
                                  _startDate =
                                      _endDate.subtract(difference);
                                  _startTime = TimeOfDay(
                                      hour: _startDate.hour,
                                      minute: _startDate.minute);
                                }
                              });
                            }
                          }
                      )),
                ]
            ),
          ),

          const Divider(
            height: 1.0,
            thickness: 0.5,
          ),

          new TextButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            child: Text('Close'),),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
              toolbarHeight: 45,
              title: Text(getTile(),),
              backgroundColor: Colors.redAccent,

              leading: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.done,
                    color: Colors.white,),
                  onPressed: () async {

                    // final Meeting? startTimeAppointment =
                    // _isInterceptExistingAppointments(
                    //     _startDate, _selectedAppointment!);
                    // final Meeting? endTimeAppointment =
                    // _isInterceptExistingAppointments(
                    //     _endDate, _selectedAppointment!);
                    //
                    // AlertDialog alert;
                    // if (startTimeAppointment != null ||
                    //     endTimeAppointment != null) {
                    //   Widget okButton = TextButton(
                    //     child: const Text("Ok"),
                    //     onPressed: () {
                    //       Navigator.pop(context, true);
                    //     },
                    //   );
                    //   alert = AlertDialog(
                    //     title: const Text("Alert"),
                    //     content: const Text('Have intercept with existing'),
                    //     actions: [
                    //       okButton,
                    //     ],
                    //   );
                    //
                    //   await showDialog<bool>(
                    //     context: context,
                    //     builder: (BuildContext context) {
                    //       return alert;
                    //     },
                    //   );
                    //
                    //   return;
                    // }

                    final List<Meeting> meetings = <Meeting>[];
                    if (_selectedAppointment != null){
                      _events.appointments!.removeAt(_events.appointments!
                          .indexOf(_selectedAppointment));
                      _events.notifyListeners(CalendarDataSourceAction.remove,
                          <Meeting>[]..add(_selectedAppointment!));
                    }
                    meetings.add(Meeting(
                      from: _startDate,
                      to: _endDate,
                      background: Colors.redAccent,
                      //description: _notes,
                      isAllDay: _isAllDay,
                      eventName: _subject == '' ? '(No Title)' : _subject,
                      //recurrenceRule:
                    ));

                    _events.appointments!.add(meetings[0]);

                    _events.notifyListeners(
                        CalendarDataSourceAction.add, meetings);
                    _selectedAppointment = null;

                    Navigator.pop(context);
                  },
                )
              ]

          ),
          body: Stack(
            children: [_getAppointmentEditor(context)],
          ),
          floatingActionButton: _selectedAppointment == null
              ? const Text('') :
          FloatingActionButton(
            onPressed: (){
              if (_selectedAppointment != null){
                _events.appointments!.removeAt(
                    _events.appointments!.indexOf(_selectedAppointment));

                _events.notifyListeners(CalendarDataSourceAction.remove,
                    <Meeting>[]..add(_selectedAppointment!));
                _selectedAppointment = null;
                Navigator.pop(context);
              }
            },
            child: const Icon(
              Icons.delete_outline,
              color: Colors.white,)
            ,),

        )
    );
  }

  String getTile() {
    return _subject.isEmpty ? 'New Event' : 'Event Details';
}

  dynamic _isInterceptExistingAppointments(
      DateTime date, Meeting selectedAppointment) {
    if (date == null ||
        _events == null ||
        _events.appointments == null ||
        _events.appointments!.isEmpty) return null;
    for (int i = 0; i < _events.appointments!.length; i++) {
      var appointment = _events.appointments![i];
      if (appointment != selectedAppointment &&
          (date.isAfter(appointment.from) ||
              _isSameDateTime(date, appointment.from)) &&
          date.isBefore(appointment.to)) {
        return appointment;
      }
    }
    return null;
  }

  bool _isSameDateTime(DateTime date1, DateTime date2) {
    if (date1 == date2) {
      return true;
    }

    if (date1 == null || date2 == null) {
      return false;
    }

    if (date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day &&
        date1.hour == date2.hour &&
        date1.minute == date2.minute) {
      return true;
    }

    return false;
  }



}