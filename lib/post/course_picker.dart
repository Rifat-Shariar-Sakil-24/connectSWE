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
      content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            padding: const EdgeInsets.all(0),
            itemCount: eventNameCollection.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                contentPadding: const EdgeInsets.all(0),
                leading: Icon(
                    index == _selectedColorIndex
                        ? Icons.lens
                        : Icons.trip_origin,
                    color: _colorCollection[index]),
                title: Text(eventNameCollection[index]),
                onTap: () {
                  setState(() {
                    _subject = eventNameCollection[index];
                  });

                  Future.delayed(const Duration(milliseconds: 200), () {
                    Navigator.pop(context);
                  });
                },
              );
            },
          )),
    );
  }
}