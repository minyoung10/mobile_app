import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MeetingTab extends StatefulWidget {
  final String id;
  const MeetingTab({super.key, required this.id});
  @override
  State<MeetingTab> createState() => MeetingTabState();
}

class MeetingTabState extends State<MeetingTab> {
  final firestore = FirebaseFirestore.instance;
  String? roomDataId;
  String? userindex;
  var scroll = ScrollController();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: firestore.collection('Biginfo').snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final docs = snapshot.data!.docs;
        final filteredDocs =
            docs.where((doc) => doc['id'] == widget.id).toList();

        // Now you can use filteredDocs to display data from Firestore
        if (filteredDocs.isNotEmpty) {
          final roomSnapshot = filteredDocs.first;
          final roomData = roomSnapshot.data();

          return Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(left: 25, right: 25, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GridView.builder(
                      padding: const EdgeInsets.only(top: 0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 0,
                      ),
                      itemCount: roomData['users_name'].length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        final temp = roomData['users_id'][index];

                        final Timestamp timestamp = roomData['register-time'];
                        DateTime dateTime = timestamp.toDate();
                        String formattedDateTime =
                            DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
                        return GestureDetector(
                            onTap: () {},
                            child: SizedBox(
                              width: 111,
                              height: 111,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.6),
                                      BlendMode.darken,
                                    ),
                                    child: ClipRRect(
                                      child: Image.network(
                                        roomData['users_image'][temp],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 100,
                                    left: 20,
                                    child: Text(
                                      formattedDateTime,
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: 8,
                                        fontWeight: FontWeight.w700,
                                        color: roomData['users_image'][temp] !=
                                                null
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ));
                      },
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Text('No data found.');
        }
      },
    );
  }
}
