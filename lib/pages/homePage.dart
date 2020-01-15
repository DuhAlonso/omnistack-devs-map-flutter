import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'webViewPage.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Position minhaPosicao;

  CameraPosition _kGooglePlex;

  Completer<GoogleMapController> _controller = Completer();

  _getMyPos() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);

    setState(() {
      minhaPosicao = currentLocation;
      _kGooglePlex = CameraPosition(
        target: LatLng(minhaPosicao.latitude, minhaPosicao.longitude),
        zoom: 16.0,
      );
    });
  }

  @override
  void initState() {
    _getMyPos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final phoneW = MediaQuery.of(context).size.width;
    final phoneH = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mapa de Devs',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: minhaPosicao == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: <Widget>[
                GoogleMap(
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  zoomGesturesEnabled: true,
                  markers: Set<Marker>.of(
                    [
                      Marker(
                        markerId: MarkerId('marker_casa'),
                        position: LatLng(
                            minhaPosicao.latitude, minhaPosicao.longitude),
                        infoWindow: InfoWindow(
                            anchor: Offset.zero,
                            title: 'Minha marca',
                            snippet: "Marca de algum lugar aí",
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => Perfil()),
                              );
                            }),
                      ),
                    ],
                  ),
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: phoneW * 0.04),
                        child: Container(
                          height: phoneH * 0.08,
                          width: phoneW * 0.7,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 19.0, right: 15, left: 15),
                              child: TextField(
                                style:
                                    TextStyle(decoration: TextDecoration.none),
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: phoneW * 0.05,
                                        vertical: phoneH * 0.0105),
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                        fontStyle: FontStyle.italic),
                                    hintText: 'Buscar por tecnologias...'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0, bottom: 20),
                        child: FloatingActionButton(
                          child: Icon(Icons.gps_fixed),
                          onPressed: () {},
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}