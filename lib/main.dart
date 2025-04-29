import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fl_chart/fl_chart.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CheckInAdapter());
  await Hive.openBox<CheckIn>('checkIns');
  runApp(const HealthMonitorApp());
}

@HiveType(typeId: 0)
class CheckIn {
  @HiveField(0) final DateTime date;
  @HiveField(1) final double energie;
  @HiveField(2) final String humeur;
  @HiveField(3) final String symptomes;
  @HiveField(4) final double qualiteSommeil;
  @HiveField(5) final double stress;
  @HiveField(6) final String conseil;
  @HiveField(7) final double hydratation;
  @HiveField(8) final double activite;
  @HiveField(9) final double engagementTravail;

  CheckIn({
    required this.date,
    required this.energie,
    required this.humeur,
    required this.symptomes,
    required this.qualiteSommeil,
    required this.stress,
    required this.conseil,
    required this.hydratation,
    required this.activite,
    required this.engagementTravail,
  });
}

class CheckInAdapter extends TypeAdapter<CheckIn> {
  @override final int typeId = 0;
  @override
  CheckIn read(BinaryReader reader) => CheckIn(
    date: reader.read(),
    energie: reader.read(),
    humeur: reader.read(),
    symptomes: reader.read(),
    qualiteSommeil: reader.read(),
    stress: reader.read(),
    conseil: reader.read(),
    hydratation: reader.read(),
    activite: reader.read(),
    engagementTravail: reader.read(),
  );
  @override
  void write(BinaryWriter writer, CheckIn obj) {
    writer.write(obj.date);
    writer.write(obj.energie);
    writer.write(obj.humeur);
    writer.write(obj.symptomes);
    writer.write(obj.qualiteSommeil);
    writer.write(obj.stress);
    writer.write(obj.conseil);
    writer.write(obj.hydratation);
    writer.write(obj.activite);
    writer.write(obj.engagementTravail);
  }
}

class HealthMonitorApp extends StatelessWidget {
  const HealthMonitorApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Monitor Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

enum Onglet { saisie, historique, analytics }

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Onglet _current = Onglet.saisie;
  final _symptomesCtrl = TextEditingController();

  double _energie = 5;
  String _humeur = 'Neutre';
  double _qualiteSommeil = 5;
  double _stress = 5;
  double _hydratation = 5;
  double _activite = 5;
  double _engagement = 5;

  final _humeurs = ['Très Négative','Négative','Neutre','Positive','Très Positive'];

  String _genereConseil() {
    final conseils = <String>[];
    if (_energie < 4 && _humeurs.indexOf(_humeur) < 2) conseils.add('Faible énergie et humeur. Repos conseillé.');
    if (_qualiteSommeil < 4) conseils.add('Sommeil de mauvaise qualité. Améliorer la routine.');
    if (_stress > 7) conseils.add('Stress élevé. Techniques de relaxation.');
    if (_hydratation < 4) conseils.add('Hydratation faible. Boire plus d’eau.');
    if (_activite < 4) conseils.add('Activité physique faible. Faites une promenade.');
    if (_engagement < 4) conseils.add('Engagement au travail faible. Faire des pauses.');
    switch(_humeur) {
      case 'Très Négative': conseils.add('Humeur très négative. Parlez-en à un proche.'); break;
      case 'Négative': conseils.add('Humeur négative. Activités plaisantes recommandées.'); break;
      default: break;
    }
    if (_symptomesCtrl.text.isNotEmpty) conseils.add('Symptômes notés. Consulter un professionnel.');
    if (_energie>7&&_qualiteSommeil>7&&_stress<4&&_hydratation>7&&_activite>7&&_engagement>7) conseils.add('État excellent ! Continuez ainsi.');
    if (conseils.isEmpty) conseils.add('Maintenez l’équilibre: repos, hydratation, exercice.');
    return conseils.join('\n');
  }

  void _sauvegarde() {
    final c = CheckIn(
      date: DateTime.now(),
      energie: _energie,
      humeur: _humeur,
      symptomes: _symptomesCtrl.text,
      qualiteSommeil: _qualiteSommeil,
      stress: _stress,
      conseil: _genereConseil(),
      hydratation: _hydratation,
      activite: _activite,
      engagementTravail: _engagement,
    );
    Hive.box<CheckIn>('checkIns').add(c);
    setState((){ _energie=_qualiteSommeil=_stress=_hydratation=_activite=_engagement=5; _humeur='Neutre'; _symptomesCtrl.clear(); });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Enregistré')));
  }

  void _videHistorique() {
    Hive.box<CheckIn>('checkIns').clear();
    setState((){});
  }

  @override void dispose(){ _symptomesCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Monitor Pro'),
        actions: _current==Onglet.historique
          ? [IconButton(icon: const Icon(Icons.delete), onPressed: _videHistorique)]
          : null,
      ),
      body: _body(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _current.index,
        onDestinationSelected: (i)=>setState(()=>_current=Onglet.values[i]),
        destinations: const[
          NavigationDestination(icon:Icon(Icons.health_and_safety),label:'Saisie'),
          NavigationDestination(icon:Icon(Icons.history),label:'Historique'),
          NavigationDestination(icon:Icon(Icons.bar_chart),label:'Analytics'),
        ],
      ),
    );
  }

  Widget _body(){
    switch(_current){
      case Onglet.historique: return _vueHistorique();
      case Onglet.analytics: return _vueAnalytics();
      default: return _vueSaisie();
    }
  }

  Widget _vueSaisie(){
    return ListView(padding:const EdgeInsets.all(16),children:[
      _curseur('Énergie',_energie,(v)=>setState(()=>_energie=v)),
      _curseur('Sommeil',_qualiteSommeil,(v)=>setState(()=>_qualiteSommeil=v)),
      _curseur('Stress',_stress,(v)=>setState(()=>_stress=v)),
      _curseur('Hydratation',_hydratation,(v)=>setState(()=>_hydratation=v)),
      _curseur('Activité',_activite,(v)=>setState(()=>_activite=v)),
      _curseur('Engagement',_engagement,(v)=>setState(()=>_engagement=v)),
      DropdownButtonFormField<String>(value:_humeur,items:_humeurs.map((h)=>DropdownMenuItem(value:h,child:Text(h))).toList(),onChanged:(v)=>setState(()=>_humeur=v!),decoration:const InputDecoration(labelText:'Humeur')),
      TextField(controller:_symptomesCtrl,decoration:const InputDecoration(labelText:'Symptômes (facultatif)'),maxLines:3),
      const SizedBox(height:20),
      ElevatedButton(onPressed:_sauvegarde,child:const Text('Enregistrer'))
    ]);
  }

  Widget _curseur(String label,double val,ValueChanged<double> onChanged){
    return Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Text(label),
      Slider(value:val,min:0,max:10,divisions:10,label:val.toStringAsFixed(0),onChanged:onChanged),
      const SizedBox(height:8),
    ]);
  }

  Widget _vueHistorique(){
    return ValueListenableBuilder<Box<CheckIn>>(valueListenable:Hive.box<CheckIn>('checkIns').listenable(),builder:(c,box,_) {
      final vals=box.values.toList().reversed.toList();
      if(vals.isEmpty) return const Center(child:Text('Aucun enregistrement'));
      return ListView.builder(itemCount:vals.length,padding:const EdgeInsets.all(16),itemBuilder:(ctx,i){
        final e=vals[i];
        return Card(child:ExpansionTile(
          title:Text('${e.date.day}/${e.date.month}/${e.date.year} - ${e.humeur}'),
          children:[Padding(padding:const EdgeInsets.all(16),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
            _ligne('Énergie',e.energie),_ligne('Sommeil',e.qualiteSommeil),_ligne('Stress',e.stress),_ligne('Hydratation',e.hydratation),_ligne('Activité',e.activite),_ligne('Engagement',e.engagementTravail),
            if(e.symptomes.isNotEmpty) Text('Symptômes: ${e.symptomes}'),
            const SizedBox(height:8),Text('Conseil:',style:TextStyle(fontWeight:FontWeight.bold)),Text(e.conseil)
          ]))]
        ));
      });
    });
  }

  Widget _ligne(String lab,double v)=>Padding(padding:const EdgeInsets.symmetric(vertical:4),child:Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[Text(lab),Text(v.toStringAsFixed(0))]));

  Widget _vueAnalytics(){
    final data=Hive.box<CheckIn>('checkIns').values.toList();
    if(data.isEmpty) return const Center(child:Text('Pas de données'));
    return CustomScrollView(slivers:[
      SliverToBoxAdapter(child:Padding(padding:const EdgeInsets.all(16),child:_graphTrend(data))),
      SliverToBoxAdapter(child:Padding(padding:const EdgeInsets.all(16),child:_graphDist(data))),
    ]);
  }

  Widget _graphTrend(List<CheckIn> d){
    return Card(child:Column(children:[const SizedBox(height:16),const Text('Tendances'),SizedBox(height:300,child:LineChart(LineChartData(
      gridData:FlGridData(show:true),titlesData:FlTitlesData(
        bottomTitles:AxisTitles(sideTitles:SideTitles(showTitles:true,getTitlesWidget:(v,m){final i=v.toInt();if(i<0||i>=d.length)return const SizedBox();return Text('${d[i].date.day}/${d[i].date.month}');})),
        leftTitles:AxisTitles(sideTitles:SideTitles(showTitles:true)),),
      lineBarsData:[_line(d.map((e)=>e.energie).toList()),_line(d.map((e)=>e.qualiteSommeil).toList()),_line(d.map((e)=>e.stress).toList())]
    ))),const SizedBox(height:8),_legend(['Énergie','Sommeil','Stress'])]));
  }

  LineChartBarData _line(List<double> vals)=>LineChartBarData(spots:vals.asMap().entries.map((e)=>FlSpot(e.key.toDouble(),e.value)).toList(),isCurved:true,barWidth:2,dotData:FlDotData(show:false),belowBarData:BarAreaData(show:false),color:Colors.blue);

  Widget _legend(List<String> items)=>Row(mainAxisAlignment:MainAxisAlignment.center,children:items.map((t)=>Padding(padding:const EdgeInsets.symmetric(horizontal:8),child:Row(children:[Container(width:12,height:12,color:Colors.blue),const SizedBox(width:4),Text(t)]))).toList());

  Widget _graphDist(List<CheckIn> d){
    final bins=List.filled(11,0);
    for(var e in d) {
      bins[e.qualiteSommeil.toInt()]++;
    }
    return Card(child:Column(children:[const SizedBox(height:16),const Text('Distribution du sommeil'),SizedBox(height:200,child:BarChart(BarChartData(
      alignment:BarChartAlignment.spaceAround,
      barGroups:bins.asMap().entries.map((e)=>BarChartGroupData(x:e.key,barRods:[BarChartRodData(toY:e.value.toDouble(),color:Colors.blue)]) ).toList(),
      titlesData:FlTitlesData(bottomTitles:AxisTitles(sideTitles:SideTitles(showTitles:true)),leftTitles:AxisTitles(sideTitles:SideTitles(showTitles:true)))
    )))]));
  }
}
