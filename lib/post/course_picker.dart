part of calendar;

class _CoursePicker extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CoursePickerState();
  }
}

class _CoursePickerState extends State<_CoursePicker> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //backgroundColor: Colors.white70,
      content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(0),
            itemCount: eventNameCollection.length ,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: Text(eventNameCollection[index],
                  style: const TextStyle(
                    fontSize: 18,
                    //color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  textColor: _colorCollection[index],
                  onTap: () {
                    setState(() {
                      _subject = eventNameCollection[index];
                      _selectedColorIndex = index;
                    });

                    Future.delayed(const Duration(milliseconds: 200), () {
                      Navigator.pop(context);
                    });
                  },
                ),
              );
            },
          )),
    );
  }
}