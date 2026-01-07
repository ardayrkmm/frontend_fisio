// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class CarouselWidget extends ConsumerWidget {
//   const CarouselWidget({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final currentIndex = ref.watch(carouselIndexProvider);

//     return Column(
//       children: [
//         SizedBox(
//           height: 220,
//           child: PageView.builder(
//             controller: PageController(viewportFraction: 0.85),
//             itemCount: carouselData.length,
//             onPageChanged: (index) {
//               ref.read(carouselIndexProvider.notifier).state = index;
//             },
//             itemBuilder: (context, index) {
//               final item = carouselData[index];

//               return Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(24),
//                   child: Stack(
//                     fit: StackFit.expand,
//                     children: [
//                       /// Background Image
//                       Image.asset(item.image, fit: BoxFit.cover),

//                       /// Gradient Overlay
//                       Container(
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                             colors: [
//                               Colors.transparent,
//                               Colors.black.withOpacity(0.7),
//                             ],
//                           ),
//                         ),
//                       ),

//                       /// Text Content
//                       Positioned(
//                         left: 16,
//                         right: 16,
//                         bottom: 16,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               item.title,
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Row(
//                               children: [
//                                 const Icon(
//                                   Icons.access_time,
//                                   color: Colors.white70,
//                                   size: 14,
//                                 ),
//                                 const SizedBox(width: 4),
//                                 Text(
//                                   item.time,
//                                   style: const TextStyle(
//                                     color: Colors.white70,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),

//         const SizedBox(height: 12),

//         /// Indicator (Dot)
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: List.generate(
//             carouselData.length,
//             (index) => AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               margin: const EdgeInsets.symmetric(horizontal: 4),
//               width: currentIndex == index ? 18 : 8,
//               height: 8,
//               decoration: BoxDecoration(
//                 color: currentIndex == index
//                     ? Colors.blue
//                     : Colors.grey.shade400,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
// class CarouselItem {
//   final String image;
//   final String title;
//   final String time;

//   CarouselItem({
//     required this.image,
//     required this.title,
//     required this.time,
//   });
// }
