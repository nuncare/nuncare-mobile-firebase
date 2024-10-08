import 'package:flutter/material.dart';
import 'package:nuncare_mobile_firebase/components/my_annuary_drawer.dart';
import 'package:nuncare_mobile_firebase/components/my_loading.dart';
import 'package:nuncare_mobile_firebase/components/my_user_card.dart';
import 'package:nuncare_mobile_firebase/models/user_model.dart';
import 'package:nuncare_mobile_firebase/screens/annuary/custom_annuary_screen_search_page.dart';
import 'package:nuncare_mobile_firebase/screens/annuary/location_screen_page.dart';
import 'package:nuncare_mobile_firebase/screens/profile/kyc_page_screen.dart';
import 'package:nuncare_mobile_firebase/services/resource_service.dart';
import 'package:nuncare_mobile_firebase/services/user_service.dart';

class AnnuaryPageScreen extends StatefulWidget {
  const AnnuaryPageScreen({super.key});

  @override
  State<AnnuaryPageScreen> createState() => _AnnuaryPageScreenState();
}

class _AnnuaryPageScreenState extends State<AnnuaryPageScreen> {
  final ResourceService _resourceService = ResourceService();
  final TextEditingController _searchTextController = TextEditingController();
  final UserService _userService = UserService();

  Doctor currentUser = Doctor.defaultDoctor();

  List<Doctor> doctors = [];
  var _isLoading = false;

  void getInformationsFromStore() async {
    try {
      setState(() {
        _isLoading = true;
      });

      Doctor response = await _userService.getInformations();

      setState(() {
        currentUser = response;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void getDoctorsFromStore() async {
    try {
      setState(() {
        _isLoading = true;
      });

      List<Doctor> response = await _resourceService.getDoctors();

      setState(() {
        doctors = response;
        _isLoading = false;
      });
    } catch (error) {
      print(error);
    }
  }

  void _searchDoctorsFromStore() async {
    try {
      setState(() {
        _isLoading = true;
      });

      List<Doctor> response = await _resourceService
          .searchDoctors(_searchTextController.text.trim());

      setState(() {
        doctors = response;
        _isLoading = false;
      });
    } catch (error) {
      print(error);
    }
  }

  void _searchDoctorsByLocationFromStore(String lat, String lng) async {
    try {
      setState(() {
        _isLoading = true;
      });

      List<Doctor> response = await _resourceService.localizeDoctors(lat, lng);

      setState(() {
        doctors = response;
        _isLoading = false;
      });
    } catch (error) {
      print(error);
    }
  }

  void _searchDoctorsWithParametersFromStore(
    String district,
    String region,
    String city,
    String speciality,
    String promotion,
    String university,
    String gender,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });

      List<Doctor> response =
          await _resourceService.searchDoctorsWithParameters(
        district,
        region,
        city,
        speciality,
        promotion,
        university,
        gender,
      );

      setState(() {
        doctors = response;
        _isLoading = false;
      });
    } catch (error) {
      print(error);
    }
  }

  void _openSearchModal(BuildContext context) async {
    final result = await showModalBottomSheet(
      useSafeArea: true,
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.white,
      builder: (ctx) => const LocationScreenPage(),
    );

    if (result != null) {
      _searchDoctorsByLocationFromStore(
        result["lat"].toString(),
        result['lng'].toString(),
      );
    }
  }

  void _openCustomSearchModal(BuildContext context) async {
    final result = await showModalBottomSheet(
      useSafeArea: true,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (ctx) => const CustomAnnuaryScreenPage(),
    );

    print("resulat du pop : $result");

    if (result != null) {
      _searchDoctorsWithParametersFromStore(
        result['district'] ?? '',
        result["region"] ?? '',
        result["city"] ?? '',
        result['speciality'] ?? '',
        result['promotion'] ?? '',
        result["university"] ?? '',
        result["gender"] ?? '',
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getInformationsFromStore();
      getDoctorsFromStore();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Annuaire des medecins',
          style: TextStyle(color: Colors.black, fontSize: 17),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _openSearchModal(context);
            },
            icon: const Icon(
              Icons.location_on,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {
              _openCustomSearchModal(context);
            },
            icon: const Icon(
              Icons.tune,
              size: 30,
            ),
          ),
        ],
      ),
      drawer: MyAnnuaryDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tous les medecins de Nuncare',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Retrouvez tous les medecins inscrits sur la plateforme en recherchant par nom dans la barre de recherche",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _searchTextController,
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                      hintText: "Entrez le nom d'un médecin",
                      suffixIcon: InkWell(
                        onTap: _searchDoctorsFromStore,
                        child: const Icon(
                          Icons.search,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: _buildView(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildView() {
    if (_isLoading == true) {
      return const Center(
        child: MyFadingCircleLoading(),
      );
    }

    if (!_isLoading && !currentUser.isActive) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              textAlign: TextAlign.center,
              'Annuaire indisponible pour le moment, votre identification est requise',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => const KycPageScreen(),
                  ),
                );
              },
              child: const Text(
                'Verifier le profil',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                ),
              ),
            )
          ],
        ),
      );
    }

    if (doctors.isEmpty) {
      return Center(
        child: Column(
          children: [
            const Text(
              "Aucun docteur dans l'annuaire",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: getDoctorsFromStore,
              child: const Text(
                "Actualiser la liste",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                ),
              ),
            )
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: doctors.length,
      itemBuilder: (ctx, index) {
        var doctor = doctors[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2.5),
          child: GestureDetector(
            onLongPress: () => print('Doctor : ${doctor.firebaseId}'),
            child: MyUserCard(doctor: doctor),
          ),
        );
      },
    );
  }
}
