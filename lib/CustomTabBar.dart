import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTabBar extends AnimatedWidget implements PreferredSizeWidget{
  CustomTabBar({this.pageController, this.pageNames})
  :super(listenable :pageController);

  final PageController pageController;
  final List<String> pageNames;

  @override
  final Size preferredSize=Size(0.0,70.0);

  @override
  Widget build(BuildContext context){
    return Container(
      height: 40.0,
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisAlignment:MainAxisAlignment.spaceBetween,
        
        children: List.generate(pageNames.length, (int index){
          return InkWell
          (child: Text(
            pageNames[index],
            style: TextStyle(
              fontSize: 17.0,
              color: Colors.white.withOpacity(
                index==pageController.page ? 1.0:0.6),
              fontWeight:FontWeight.bold,
              
                ) 
                ),
          onTap: (){
            pageController.animateToPage(
              index,
              curve:Curves.easeOut,
              duration: const Duration(milliseconds: 300)
            );});
          }     
          ) .toList(),
        ),
    );
  }
}
