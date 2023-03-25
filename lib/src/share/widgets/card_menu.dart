import 'package:flutter/material.dart';

class CardMenu extends StatelessWidget {
  final String title;
  final Widget? screenRoute;
  final IconData icon;

  const CardMenu({Key? key, required this.title, this.screenRoute, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => screenRoute!,
          ),
        );
      },
      child: SizedBox(
        width: 310,
        child: Card(
          child: Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4),
                    bottomLeft: Radius.circular(4),
                  ),
                ),
                width: 100,
                height: 100,
                child: Icon(icon, color: Colors.white, size: 50),
              ),
              SizedBox(
                width: 200,
                height: 100,
                child: Center(
                  child: Text(title, textAlign: TextAlign.center,style: const TextStyle(fontSize: 20),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
