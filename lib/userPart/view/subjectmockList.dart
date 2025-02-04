import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../domain/sharedPre.dart';
import '../handleNavi/MockNavi.dart';
import '../repostory/scoreRepo.dart';
import '../widgets/mockContainer.dart';

class Subjectmocklist extends StatefulWidget {
  final String subjectName;

  Subjectmocklist({required this.subjectName});

  @override
  _SubjectmocklistState createState() => _SubjectmocklistState();
}

class _SubjectmocklistState extends State<Subjectmocklist> {
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
    String? email = await SharedPrefs().getEmail();
    if (mounted) {
      setState(() {
        userEmail = email;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.subjectName} - Mocks'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: userEmail == null
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('series')
                  .doc(widget.subjectName)
                  .collection('mocks')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('Upcoming Soon!'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index];
                    final docData = doc.data() as Map<String, dynamic>;
                    final mockTestName = docData['name'];
                    final bool isPaid = docData['paid'] ?? false;
                    print("🔥 Mock: $mockTestName | Paid: $isPaid");

                    return FutureBuilder<double?>(
                      future: ScoreRepo.getScore(
                        subject: widget.subjectName,
                        mockTest: mockTestName,
                      ),
                      builder: (context, scoreSnapshot) {
                        if (scoreSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox();
                        }

                        double score = scoreSnapshot.data ?? 0.0;
                        print("📊 Score Data: $mockTestName | Score: $score");

                        return GestureDetector(
                          onTap: () {
                            print("🖱 Clicked: $mockTestName | Paid: $isPaid");

                            HandleNavi.navigateToMockTestOrPayment(
                                context: context,
                                mockTestName: mockTestName,
                                isPaid: isPaid,
                                userEmail: userEmail.toString(),
                                subjectName: widget.subjectName);
                          },
                          child: CustomMockContainer(
                            mock: mockTestName,
                            index: index + 1,
                            subject: widget.subjectName,
                            lockIcon: isPaid,
                            // Show lock icon only for paid mocks
                            score: score,
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}
