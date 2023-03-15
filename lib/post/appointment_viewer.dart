part of calendar;

class AppointmentViewer extends StatefulWidget{

  const AppointmentViewer({super.key});

  @override
  AppointmentViewerState createState() => AppointmentViewerState();
}

class AppointmentViewerState extends State<AppointmentViewer>{
  Widget _getAppointmentViewer(BuildContext context){
    return Container(
      color: Palette.backgroundColor,
      child: ListView(
        children: [

          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
            leading: const Icon(
              Icons.bookmark,
              color: Colors.black87,
            ),
            title: Text(_subject == '' ? '(No Title)' : _subject,
              style: const TextStyle(
                fontSize: 25,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),),
          ),

          const Divider(
            height: 1.0,
            thickness: 0.5,
          ),

          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
            leading: const Icon(
              Icons.book,
              color: Colors.black87,
            ),
            title: Text(_courseName == '' ? '(No Title)' : _courseName,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),),
          ),

          const Divider(
            height: 1.0,
            thickness: 0.5,
          ),

          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
            leading: const Icon(
              Icons.person,
              color: Colors.black87,
            ),
            title: Text(_courseName == '' ? '(No Title)' : _teacherName,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),),
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
                            onChanged: null,
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
                      )
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
                    ),
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
                  Expanded(child: GestureDetector(
                      child: Text(
                        DateFormat('EEE, MM.dd.yyyy').
                        format(_endDate),
                        textAlign: TextAlign.left,
                      ),
                  ),
                  ),

                  Expanded(
                      child: _isAllDay
                          ? const Text(''):
                      GestureDetector(
                          child: Text(
                            DateFormat('hh:mm a').
                            format(_endDate),
                            textAlign: TextAlign.right,
                          ),
                      )
                  ),
                ]
            ),
          ),

          const Divider(
            height: 1.0,
            thickness: 0.5,
          ),

          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
            leading: Icon(Icons.lens,
                color: _colorCollection[_selectedColorIndex]),
            title: Text(
              _colorNames[_selectedColorIndex],
            ),
          ),

          ListTile(
            contentPadding: const EdgeInsets.all(5),
            leading: const Icon(
              Icons.subject,
              color: Colors.black87,
            ),
            title: Text(_notes == '' ? '(No Description found)' : _notes,
            style: const TextStyle(
                fontSize: 18,
                color: Colors.black87,
                fontWeight: FontWeight.w400),)
            ),
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
              backgroundColor: _colorCollection[_selectedColorIndex],

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
                    Navigator.pop(context);
                  },
                )
              ]
          ),

          body: Stack(
            children: [_getAppointmentViewer(context)],
          ),
        )
    );
  }

  String getTile() {
    return _subject.isEmpty ? 'New Event' : 'Event Details';
  }
}