import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_club_colors.dart';
import 'package:flutter_fight_club/fight_club_icons.dart';
import 'package:flutter_fight_club/fight_club_images.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.pressStart2pTextTheme(
          Theme.of(context)
              .textTheme, // If this is not set, then ThemeData.light().textTheme is used.
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const maxLives = 5;

  BodyPart? defendingBodyPart;
  BodyPart? attackingBodyPart;

  BodyPart whatEnemyAttacks = BodyPart.random();
  BodyPart whatEnemyDefends = BodyPart.random();

  int yourLives = maxLives;
  int enemiesLives = maxLives;

  String centerText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FightClubColors.background,
      body: SafeArea(
        child: Column(
          children: [
            FightersInfo(
              maxLivesCount: maxLives,
              yoursLivesCount: yourLives,
              enemiesLivesCount: enemiesLives,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 30,
                ),
                child: ColoredBox(
                  color: FightClubColors.centerBox,
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Center(
                      child: Text(
                        centerText,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: FightClubColors.darkGreyText),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ControlsWidget(
                defendingBodyPart: defendingBodyPart,
                selectDefendingBodyPart: _selectDefendingBodyPart,
                attackingBodyPart: attackingBodyPart,
                selectAttackingBodyPart: _selectAttackingBodyPart),
            SizedBox(height: 14),
            GoButton(
              text:
                  yourLives == 0 || enemiesLives == 0 ? "Start new game" : "Go",
              onTap: _onGoButtonClicked,
              color: _getGoButtonColor(),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Color _getGoButtonColor() {
    if (yourLives == 0 || enemiesLives == 0) {
      return FightClubColors.blackButton;
    } else if (attackingBodyPart == null || defendingBodyPart == null) {
      return FightClubColors.greyButton;
    } else {
      return FightClubColors.blackButton;
    }
  }

  void _onGoButtonClicked() {
    if (yourLives == 0 || enemiesLives == 0) {
      setState(() {
        yourLives = maxLives;
        enemiesLives = maxLives;
      });
    } else if (defendingBodyPart != null && attackingBodyPart != null) {
      setState(() {
        final bool enemyLoseLife = attackingBodyPart != whatEnemyDefends;
        final bool youLoseLife = defendingBodyPart != whatEnemyAttacks;
        if (enemyLoseLife) {
          enemiesLives -= 1;
        }
        if (youLoseLife) {
          yourLives -= 1;
        }

        if (enemiesLives == 0 && yourLives == 0) {
          centerText = "Draw";
        } else if (yourLives == 0) {
          centerText = "You lost";
        } else if (enemiesLives == 0) {
          centerText = "You won";
        } else {
          String firstLine = enemyLoseLife
              ? "You hit enemy's ${attackingBodyPart!.name.toLowerCase()}."
              : "Your attack was blocked.";

          String secondLine = youLoseLife
              ? "Enemy hit your ${whatEnemyAttacks.name.toLowerCase()}."
              : "Enemy's attack was blocked.";
          centerText = "$firstLine\n$secondLine";
        }

        whatEnemyDefends = BodyPart.random();
        whatEnemyAttacks = BodyPart.random();

        defendingBodyPart = null;
        attackingBodyPart = null;
      });
    }
  }

  void _selectDefendingBodyPart(final BodyPart value) {
    if (yourLives == 0 || enemiesLives == 0) {
      return;
    }
    setState(() {
      defendingBodyPart = value;
    });
  }

  void _selectAttackingBodyPart(final BodyPart value) {
    if (yourLives == 0 || enemiesLives == 0) {
      return;
    }
    setState(() {
      attackingBodyPart = value;
    });
  }
}

class ControlsWidget extends StatelessWidget {
  final BodyPart? defendingBodyPart;
  final ValueSetter<BodyPart> selectDefendingBodyPart;
  final BodyPart? attackingBodyPart;
  final ValueSetter<BodyPart> selectAttackingBodyPart;

  const ControlsWidget({
    Key? key,
    required this.defendingBodyPart,
    required this.selectDefendingBodyPart,
    required this.attackingBodyPart,
    required this.selectAttackingBodyPart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 16),
        Expanded(
          child: Column(
            children: [
              Text(
                "Defend".toUpperCase(),
                style: TextStyle(color: FightClubColors.darkGreyText),
              ),
              SizedBox(height: 13),
              BodyPartButton(
                bodyPart: BodyPart.head,
                selected: defendingBodyPart == BodyPart.head,
                bodyPartSetter: selectDefendingBodyPart,
              ),
              SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.torso,
                selected: defendingBodyPart == BodyPart.torso,
                bodyPartSetter: selectDefendingBodyPart,
              ),
              SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.legs,
                selected: defendingBodyPart == BodyPart.legs,
                bodyPartSetter: selectDefendingBodyPart,
              ),
            ],
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            children: [
              Text(
                "Attack".toUpperCase(),
                style: TextStyle(color: FightClubColors.darkGreyText),
              ),
              SizedBox(height: 13),
              BodyPartButton(
                bodyPart: BodyPart.head,
                selected: attackingBodyPart == BodyPart.head,
                bodyPartSetter: selectAttackingBodyPart,
              ),
              SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.torso,
                selected: attackingBodyPart == BodyPart.torso,
                bodyPartSetter: selectAttackingBodyPart,
              ),
              SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.legs,
                selected: attackingBodyPart == BodyPart.legs,
                bodyPartSetter: selectAttackingBodyPart,
              ),
            ],
          ),
        ),
        SizedBox(width: 16),
      ],
    );
  }
}

class GoButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;

  const GoButton({
    Key? key,
    required this.onTap,
    required this.color,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          height: 40,
          child: ColoredBox(
            color: color,
            child: Center(
              child: Text(
                text.toUpperCase(),
                style:
                    TextStyle(fontSize: 16, color: FightClubColors.whiteText),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FightersInfo extends StatelessWidget {
  final int maxLivesCount;
  final int yoursLivesCount;
  final int enemiesLivesCount;

  const FightersInfo({
    Key? key,
    required this.maxLivesCount,
    required this.yoursLivesCount,
    required this.enemiesLivesCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Stack(children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ColoredBox(color: FightClubColors.youSide),
            ),
            Expanded(
              child: ColoredBox(color: FightClubColors.centerBox),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            LivesWidget(
              overallLivesCount: maxLivesCount,
              currentLivesCount: yoursLivesCount,
            ),
            Column(
              children: [
                const SizedBox(height: 16),
                Text(
                  "You",
                  style: TextStyle(
                    color: FightClubColors.darkGreyText,
                  ),
                ),
                const SizedBox(height: 12),
                Image.asset(FightClubImages.youAvatar, width: 92, height: 92),
              ],
            ),
            ColoredBox(
              color: FightClubColors.greenButton,
              child: SizedBox(width: 44, height: 44),
            ),
            Column(
              children: [
                const SizedBox(height: 16),
                Text(
                  "Enemy",
                  style: TextStyle(
                    color: FightClubColors.darkGreyText,
                  ),
                ),
                const SizedBox(height: 12),
                Image.asset(FightClubImages.enemyAvatar, width: 92, height: 92),
              ],
            ),
            LivesWidget(
              overallLivesCount: maxLivesCount,
              currentLivesCount: yoursLivesCount,
            ),
          ],
        ),
      ]),
    );
  }
}

class LivesWidget extends StatelessWidget {
  final int overallLivesCount;
  final int currentLivesCount;

  const LivesWidget({
    Key? key,
    required this.overallLivesCount,
    required this.currentLivesCount,
  })  : assert(overallLivesCount >= 1),
        assert(currentLivesCount >= 0),
        assert(currentLivesCount <= overallLivesCount),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
        direction: Axis.vertical,
        spacing: 4,
        children: List.generate(overallLivesCount, (index) {
          if (index < currentLivesCount) {
            return Image.asset(FightClubIcons.heartFull, width: 18, height: 18);
          } else {
            return Image.asset(FightClubIcons.heartEmpty,
                width: 18, height: 18);
          }
        }));
  }
}

class BodyPart {
  final String name;

  const BodyPart._(this.name);

  static const head = BodyPart._("Head");
  static const torso = BodyPart._("Torso");
  static const legs = BodyPart._("Legs");

  @override
  String toString() {
    return 'BodyPart{name: $name}';
  }

  static const List<BodyPart> _values = [head, torso, legs];

  static BodyPart random() {
    return _values[Random().nextInt(_values.length)];
  }
}

class BodyPartButton extends StatelessWidget {
  final BodyPart bodyPart;
  final bool selected;
  final ValueSetter<BodyPart> bodyPartSetter;

  const BodyPartButton({
    Key? key,
    required this.bodyPart,
    required this.selected,
    required this.bodyPartSetter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => bodyPartSetter(bodyPart),
      child: SizedBox(
        height: 40,
        child: ColoredBox(
          color: selected
              ? FightClubColors.blueButton
              : FightClubColors.greyButton,
          child: Center(
            child: Text(
              bodyPart.name.toUpperCase(),
              style: TextStyle(
                color: selected
                    ? FightClubColors.whiteText
                    : FightClubColors.darkGreyText,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
