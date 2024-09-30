import 'package:flutter/material.dart';

void main() {
  runApp(CarMenuApp());
}

class CarMenuApp extends StatelessWidget {
  const CarMenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Menu App',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: CarMenuScreen(),
    );
  }
}

class CarMenuScreen extends StatefulWidget {
  const CarMenuScreen({super.key});

  @override
  _CarMenuScreenState createState() => _CarMenuScreenState();
}

class _CarMenuScreenState extends State<CarMenuScreen> {
  List<Map<String, String>> cars = [
    {
      'title': 'Седан', 
      'image': 'assets/9305.jpeg',
      'description': 'Описание седана: удобный и экономичный.'
    },
    {
      'title': 'Легковушка',
      'image': 'assets/AQABFIKIRoaubfEbmb1FGDAx8LGNuk1__VwP0inp0eWTRly1omM3B7Z3Mn2sJE8VW6nzFPdNM_9vgdM9qxZBbgK20mw.jpg',
      'description': 'Описание легковушки: идеальна для города.'
    },
  ];

  void _addCar(String title, String image, String description) {
    setState(() {
      cars.add({'title': title, 'image': image, 'description': description});
    });
  }

  void _editCar(int index, String title, String image, String description) {
    setState(() {
      cars[index] = {'title': title, 'image': image, 'description': description};
    });
  }

  void _deleteCar(int index) {
    setState(() {
      cars.removeAt(index);
    });
  }

  void _showCarForm({int? index}) {
    final titleController = TextEditingController();
    final imageController = TextEditingController();
    final descriptionController = TextEditingController();

    if (index != null) {
      titleController.text = cars[index]['title']!;
      imageController.text = cars[index]['image']!;
      descriptionController.text = cars[index]['description']!;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(index == null ? 'Добавить машину' : 'Редактировать машину'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Название'),
              ),
              TextField(
                controller: imageController,
                decoration: const InputDecoration(labelText: 'Ссылка на изображение'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Описание'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final title = titleController.text;
                final image = imageController.text;
                final description = descriptionController.text;

                if (index == null) {
                  _addCar(title, image, description);
                } else {
                  _editCar(index, title, image, description);
                }

                Navigator.of(context).pop();
              },
              child: Text(index == null ? 'Добавить' : 'Сохранить'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Отмена'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Меню машин'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCarForm(),
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        padding: const EdgeInsets.all(10),
        itemCount: cars.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CarDetailScreen(
                      title: cars[index]['title']!,
                      image: cars[index]['image']!,
                      description: cars[index]['description']!,
                    ),
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                    child: Image.asset(
                      cars[index]['image']!,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      cars[index]['title']!,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _showCarForm(index: index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteCar(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CarDetailScreen extends StatelessWidget {
  final String title;
  final String image;
  final String description;

  const CarDetailScreen({super.key, required this.title, required this.image, required this.description});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              image,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                description,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
