import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 240,
              width: double.infinity,
              child: Image.asset(
                'assets/images/img2.jpg',
                fit: BoxFit.fill,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Text(
                    '''Welcome to Daiman Sri Skudai Sports Centre (DSSSC), an extension of the renowned Daiman Johor Jaya Sports Complex. With 18 PU rubber courts and 7 premier Futsal courts, including an international-size FIFA Court, we set the standard for sports excellence.

Catering to global standards, DSSSC is the go-to destination for badminton and Futsal enthusiasts. Our facility, complete with LED lighting, ensures a top-notch experience for both professionals and recreational players.

The highlight is our international FIFA Court, ideal for hosting global competitions. Conveniently located with ample parking and top-quality amenities, Daiman Sri Skudai Sports Centre is the ultimate sports destination in Johor, attracting enthusiasts from everywhere.''',
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Close',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
