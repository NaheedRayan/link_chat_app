import 'package:flutter/material.dart';



class privacy extends StatelessWidget {
  const privacy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('Privacy'),
          centerTitle: true,
        ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Text(
                "Privacy Policy",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Polkawallet.io (“We”; “us”; or “our”) are committed to protecting and respecting your privacy. This policy (together with our terms of use on our websites https://polkawallet.io (the “Sites“) and any other documents referred to on it) sets out the basis on which any personal data we collect from you, or that you provide to us, will be processed by us. Please read the following carefully to understand our views and practices regarding your personal data and how we will treat it.",
                style: TextStyle(
                  fontSize: 16,
                  // fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              SizedBox(
                height: 20,
              ),
              Text(
                "What data do we collect from you?",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "This is information about you that you give us by filling in forms on our Sites, filling in forms on the sites of third party vendors providing us with a service, or by corresponding with us by phone, e-mail or otherwise. It includes information you provide when you agree to our contributors license agreement (“CLA”), apply for a job on our Sites, ask to receive our newsletter and when you report a problem with our Sites. The information you give us may include your name, address, e-mail address and phone number and job application information (e.g. your CV, education data, and picture).",
                style: TextStyle(
                  fontSize: 16,
                  // fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Cookies",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Our Sites uses cookies to distinguish you from other users of our Sites. This helps us to provide you with a good experience when you browse our Sites and also allows us to improve our Sites. For detailed information on the cookies we use and the purposes for which we use them see our “Cookie Policy” below.",
                style: TextStyle(
                  fontSize: 16,
                  // fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              SizedBox(
                height: 20,
              ),

            ],
          ),
        ),
      ),

    );
  }
}
