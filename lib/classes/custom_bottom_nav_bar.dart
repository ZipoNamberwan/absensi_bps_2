import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomBottomNavBar extends StatelessWidget {
  final List<BottomNavyBarItem> items;
  final Duration animationDuration;
  final double normalIconSize;
  final Color selectedColor;
  final Color unselectedColor;
  final ValueChanged<int> onItemSelected;
  final int selectedIndex;

  const CustomBottomNavBar(
      {Key key,
      @required this.items,
      this.animationDuration = const Duration(milliseconds: 300),
      this.normalIconSize = kBottomNavigationBarHeight - 25,
      this.selectedColor = Colors.blue,
      this.unselectedColor = Colors.black54,
      @required this.onItemSelected,
      this.selectedIndex = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> listItemWidget = items.map((item) {
      var index = items.indexOf(item);
      return Expanded(
        flex: 1,
        child: Container(
          child: FlatButton(
            onPressed: () {
              onItemSelected(index);
            },
            child: AnimatedBottomNavBarItem(
              icon: item.icon,
              title: item.title,
              animationDuration: animationDuration,
              normalHeight: normalIconSize,
              isSelected: (index == selectedIndex) ? true : false,
              selectedColor: selectedColor,
              unselectedColor: unselectedColor,
            ),
          ),
        ),
      );
    }).toList();

    listItemWidget.insert(
        2,
        Expanded(
          flex: 1,
          child: Container(
            height: normalIconSize,
          ),
        ));

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: listItemWidget,
    );
  }
}

class AnimatedBottomNavBarItem extends StatelessWidget {
  final Icon icon;
  final String title;
  final bool isSelected;
  final Duration animationDuration;
  final double normalHeight;
  final Color selectedColor;
  final Color unselectedColor;

  const AnimatedBottomNavBarItem(
      {Key key,
      this.icon,
      this.title,
      this.isSelected,
      this.animationDuration,
      this.normalHeight,
      this.selectedColor,
      this.unselectedColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kBottomNavigationBarHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          AnimatedContainer(
            curve: Curves.easeInCubic,
            height: isSelected ? normalHeight : normalHeight - 10,
            width: isSelected ? normalHeight : normalHeight - 10,
            duration: animationDuration,
            child: FittedBox(
              fit: BoxFit.fill,
              child: IconTheme(
                  data: IconThemeData(
                    color: isSelected ? selectedColor : unselectedColor,
                  ),
                  child: icon),
            ),
          ),
          AnimatedOpacity(
            curve: Curves.easeInCubic,
            opacity: isSelected ? 1.0 : 0.0,
            duration: animationDuration,
            child: AnimatedDefaultTextStyle(
                curve: Curves.easeInCubic,
                child: Text(title),
                style: TextStyle(
                  color: isSelected ? selectedColor : unselectedColor,
                  fontSize: isSelected ? 11 : 0,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                duration: animationDuration),
          )
        ],
      ),
    );
  }
}

class BottomNavyBarItem {
  final Icon icon;
  final String title;
  final TextAlign textAlign;

  BottomNavyBarItem({
    @required this.icon,
    @required this.title,
    this.textAlign,
  }) {
    assert(icon != null);
    assert(title != null);
  }
}
