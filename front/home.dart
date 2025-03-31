import 'package:flutter/material.dart';
import 'package:tasheha_app/Theme/colors.dart';
import 'package:tasheha_app/pages/account_screen.dart';
import 'package:tasheha_app/pages/favorite.dart';
import 'package:tasheha_app/pages/chatting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasheha_app/pages/login.dart';
import 'package:tasheha_app/widgets/search_box.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> topPlaces = [];
  List<Map<String, dynamic>> topGuides = [];
  List<Map<String, dynamic>> searchResults = [];

  Future<void> fetchTopPlaces() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/top_places/home/'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['top_places'];
      setState(() {
        topPlaces = List<Map<String, dynamic>>.from(data.map((place) => {
          'name': place['name'],
          'rate': place['rate'],
          'city': place['city'],
          'image_path': place['image_path'] 
        }));
      });
    } else {
      print('Failed to load top places: ${response.statusCode}');
    }
  }

  Future<void> fetchTopGuides() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/top_guides/home/'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['top_guides'];
      setState(() {
        topGuides = List<Map<String, dynamic>>.from(data.map((guide) => {
          'Fname': guide['Fname'],
          'personal_image': guide['personal_image'] 
        }));
      });
    } else {
      print('Failed to load top guides: ${response.statusCode}');
    }
  }

  Future<void> search(String query) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/search/?name=$query'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        searchResults = List<Map<String, dynamic>>.from(
          data['places']?.map((place) => {
            'name': place['name'],
            'type': place['type']
          }) ?? []
        );
      });
    } else {
      print('Search failed: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTopPlaces();
    fetchTopGuides();
  }

  final TextEditingController _searchController = TextEditingController();
  final List<String> cityOptions = [
    "Amman",
    "Irbid",
    "Balqa",
    "Zarqa",
    "Mafraq",
    "Jerash",
    "Ajloun",
    "Madaba",
    "Karak",
    "Tafilah",
    "Ma'an",
    "Aqaba",
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.blueC : AppColors.brownC,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    try {
      SharedPreferences pre = await SharedPreferences.getInstance();
      await pre.remove('userId');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      _showSnackBar("Logout failed", isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Discover"),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: AppColors.blueC,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Trip",
                  style: TextStyle(
                    fontFamily: 'RadioCanadaBig',
                    color: AppColors.backC,
                    fontSize: 35,
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  "JO",
                  style: TextStyle(
                    fontFamily: 'RadioCanadaBig',
                    color: AppColors.brownC,
                    fontSize: 35,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ListTile(
              leading: Icon(Icons.home, color: AppColors.backC),
              title: Text("Home", style: TextStyle(color: AppColors.backC)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.person, color: AppColors.backC),
              title: Text("Account", style: TextStyle(color: AppColors.backC)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.favorite, color: AppColors.backC),
              title: Text("Favorite places", style: TextStyle(color: AppColors.backC)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Favorite()),
                );
              },
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.chat, color: AppColors.backC),
              title: Text("Your chatting", style: TextStyle(color: AppColors.backC)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Chatting()),
                );
              },
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.logout, color: AppColors.backC),
              title: Text("Log out", style: TextStyle(color: AppColors.backC)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Log out confirmation"),
                    content: Text("Are you sure you want to log out?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          logout(context);
                        },
                        child: Text(
                          "Yes",
                          style: TextStyle(color: AppColors.blueC),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    SearchBox(
                      controller: _searchController,
                      hintText: 'Search places in Jordan...',
                      onChanged: (query) {
                        if (query.isNotEmpty) {
                          search(query);
                        }
                      },
                    ),
                    SizedBox(height: 24),
                    
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: cityOptions.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 90,
                            margin: EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: AppColors.blueC,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  cityOptions[index],
                                  style: TextStyle(
                                    color: AppColors.backC,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    
                    SizedBox(height: 32),
                    
                    Text(
                      "Popular places",
                      style: TextStyle(
                        fontFamily: 'RadioCanadaBig',
                        color: AppColors.blueC,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    SizedBox(
                      height: 220,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: topPlaces.length,
                        itemBuilder: (context, index) {
                          final place = topPlaces[index];
                          return Container(
                            width: 180,
                            margin: EdgeInsets.only(right: 16),
                            decoration: BoxDecoration(
                              color: AppColors.blueC,
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: NetworkImage(place['image_path']),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 100,
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.backC.withOpacity(0.9),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      place['name'] ?? 'Unnamed Place',
                                      style: TextStyle(
                                        fontFamily: 'RadioCanadaBig',
                                        fontSize: 16,
                                        color: AppColors.brownC,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1, 
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    
                                    SizedBox(height: 2),
                                    Text(
                                      place['city'] ?? 'Unknown City',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.brownC,
                                      ),
                                      maxLines: 1, 
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 16,
                                          color: AppColors.blueC,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          place['rate']?.toStringAsFixed(1) ?? '0.0',
                                          style: TextStyle(
                                            color: AppColors.brownC,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    
                    SizedBox(height: 32),
                    
                    Text(
                      "Guides",
                      style: TextStyle(
                        fontFamily: 'RadioCanadaBig',
                        color: AppColors.blueC,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: topGuides.length,
                        itemBuilder: (context, index) {
                          final guide = topGuides[index];
                          return Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: AppColors.blueC,
                                  backgroundImage: NetworkImage(guide['personal_image']),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  guide['Fname'] ?? 'Guide',
                                  style: TextStyle(
                                    color: AppColors.brownC,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    
                    SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60, 
        color: AppColors.blueC, 
        shape: CircularNotchedRectangle(), 
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home, color: AppColors.backC),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.favorite, color: AppColors.backC),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Favorite()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.person, color: AppColors.backC),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountScreen()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.chat, color: AppColors.backC),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Chatting()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
