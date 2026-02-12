// import 'package:flutter/material.dart';
// import 'package:goodedunote/common/const/const_response.dart';
// import 'package:goodedunote/common/const/const_size.dart';
// import 'package:goodedunote/common/component/text/custom_text_input_field.dart';
// import 'package:goodedunote/common/const/const_text.dart';
// import 'package:goodedunote/common/func/commonFunc.dart';
// import 'package:goodedunote/common/func/popupFunc.dart';
// import 'package:goodedunote/common/func/pageFunc.dart';
// import 'package:goodedunote/common/layout/default_layout.dart';
// import 'package:goodedunote/user/provider/user_provider.dart';
// import 'package:goodedunote/user/model/student_model.dart';
// import 'package:goodedunote/user/func/user_func.dart';
// import 'package:goodedunote/user/enum/user_enum.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// class StudentJoinScreen extends ConsumerStatefulWidget {
//   static String get routeName => 'studentJoin';
//   const StudentJoinScreen({super.key});
//
//   @override
//   ConsumerState<StudentJoinScreen> createState() => _StudentJoinScreenState();
// }
//
// class _StudentJoinScreenState extends ConsumerState<StudentJoinScreen> {
//   String userEmail = '';
//
//   String userId = '';
//
//   String userPw = '';
//
//   String userNm = '';
//
//   String userAlias = '';
//
//   String userPwConfirm = '';
//
//   String userPhone = '';
//
//   String schoolNm = '';
//
//   String? pwError;
//
//   String? pwConfirmError;
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(userProvider.notifier);
//
//     return DefaultLayout(
//       child: Column(
//         children: [
//           _title(),
//           const SizedBox(height: 20),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   children: [
//                     Column(
//                       children: [
//                         CustomTextInputField(
//                           onChanged: (value) {
//                             userEmail = value;
//                           },
//                           labelText: '이메일',
//                           labelTextStyle: const TextStyle(
//                             fontSize: CONST_TEXT_14,
//                           ),
//                           inputAction: TextInputAction.next,
//                         ),
//                         const SizedBox(height: CONST_SIZE_20),
//                         CustomTextInputField(
//                           onChanged: (value) {
//                             userId = value;
//                           },
//                           labelText: 'ID',
//                           labelTextStyle: const TextStyle(
//                             fontSize: CONST_TEXT_14,
//                           ),
//                           inputAction: TextInputAction.next,
//                         ),
//                         const SizedBox(height: CONST_SIZE_20),
//                         CustomTextInputField(
//                           onChanged: (value) {
//                             userPw = value;
//                             setState(() {
//                               if (userPw.length < 12) {
//                                 pwError = '비밀번호는 12자리 이상이어야 합니다.';
//                               } else {
//                                 pwError = null;
//                               }
//                             });
//                           },
//                           hideText: true,
//                           style: const TextStyle(
//                               fontFamily: 'NoToSansKR-Regular'
//                           ),
//                           labelText: '비밀번호',
//                           labelTextStyle: const TextStyle(
//                               fontSize: CONST_TEXT_14),
//                           inputAction: TextInputAction.next,
//                           errorText: pwError,
//                         ),
//                         const SizedBox(height: CONST_SIZE_20),
//                         CustomTextInputField(
//                           onChanged: (value) {
//                             userPwConfirm = value;
//
//                             setState(() {
//                               if (userPw != userPwConfirm) {
//                                 pwConfirmError = '일치하지 않는 비밀번호입니다.';
//                               } else {
//                                 pwConfirmError = null;
//                               }
//                             });
//                           },
//                           hideText: true,
//                           errorText: pwConfirmError,
//                           style: const TextStyle(
//                               fontFamily: 'NoToSansKR-Regular'
//                           ),
//                           labelText: '비밀번호 재확인',
//                           labelTextStyle: const TextStyle(
//                               fontSize: CONST_TEXT_14),
//                           inputAction: TextInputAction.next,
//                         ),
//                         const SizedBox(height: CONST_SIZE_20),
//                         CustomTextInputField(
//                           onChanged: (value) {
//                             userAlias = value;
//                           },
//                           labelText: '닉네임',
//                           labelTextStyle: const TextStyle(
//                               fontSize: CONST_TEXT_14),
//                           inputAction: TextInputAction.next,
//                         ),
//                         const SizedBox(height: CONST_SIZE_20),
//                         CustomTextInputField(
//                           onChanged: (value) {
//                             userNm = value;
//                           },
//                           labelText: '이름',
//                           labelTextStyle: const TextStyle(
//                               fontSize: CONST_TEXT_14),
//                           inputAction: TextInputAction.next,
//                         ),
//                         const SizedBox(height: CONST_SIZE_20),
//                         CustomTextInputField(
//                           onChanged: (value) {
//                             userPhone = value;
//                           },
//                           labelText: '전화번호',
//                           labelTextStyle: const TextStyle(
//                               fontSize: CONST_TEXT_14),
//                           inputAction: TextInputAction.next,
//                         ),
//                         const SizedBox(height: CONST_SIZE_20),
//                         CustomTextInputField(
//                           onChanged: (value) {
//                             schoolNm = value;
//                           },
//                           labelText: '학교명',
//                           labelTextStyle: const TextStyle(
//                               fontSize: CONST_TEXT_14),
//                           inputAction: TextInputAction.done,
//                         ),
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 30,
//                     ),
//                     ElevatedButton(
//                       onPressed: () async {
//                         String? msg = _validUserInfo();
//                         print(msg);
//                         if (msg != null) {
//                           showAlertPopUp(
//                               context: context, title: '회원가입', content: msg);
//                         } else {
//                           String msg;
//                           StudentModel model = StudentModel(
//                             userEmail: userEmail,
//                             userId: userId,
//                             userPw: userPw,
//                             userNm: userNm,
//                             userAlias: userAlias,
//                             userPhone: userPhone,
//                             user_gubun: USER_GUBUN.student,
//                             schoolNm: schoolNm,
//                           );
//                           var result = await state.join(model: model);
//                           var callbackFunc;
//
//                           if (result.responseCode != CONST_SUCCESS_CODE) {
//                             msg = '회원가입에 실패하였습니다. 사유 : ${result.responseMsg}';
//                           }else {
//                             msg = '회원가입을 축하합니다!';
//                             callbackFunc = goToMain();
//                           }
//
//                           showAlertPopUp(context: context, title: '회원가입', content: msg, onPressed: callbackFunc);
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         shape: const StadiumBorder(),
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         foregroundColor: Colors.black,
//                         backgroundColor: Colors.blue,
//                         minimumSize: const Size(140, 60),
//                         //fixedSize: Size(240, 80),
//                       ),
//                       child: const Icon(
//                         Icons.check,
//                         color: Colors.white,
//                       ),
//                     ),
//
//                   ],
//                 ),
//               ),
//             ),
//           ),
//
//           // 버튼
//         ],
//       ),
//     );
//   }
//
//   _title() {
//     return Column(
//       children: [
//         const Text(
//           '회원가입',
//           style:
//           TextStyle(fontSize: CONST_TEXT_30, fontWeight: FontWeight.bold),
//         ),
//         Text(
//           '계정을 생성하세요!',
//           style: TextStyle(fontSize: CONST_TEXT_14, color: Colors.grey[700]),
//         ),
//       ],
//     );
//   }
//
//   _joinButton(state) {
//     return ;
//   }
//
//   String? _validUserInfo() {
//     String? errorMsg;
//
//     if (userEmail != '') {
//       if (!isEmailFormat(userEmail)) {
//         errorMsg = '이메일 포멧이 아닙니다. 다시 입력해주세요.';
//       }
//     } else {
//       errorMsg = '이메일을 입력해주세요.';
//     }
//
//     if (userId == '') {
//       errorMsg = '이메일을 입력해주세요.';
//     }
//
//     if (userPw != '') {
//       if (userPw != userPwConfirm) {
//         errorMsg = '비밀번호와 2차 비밀번호가 일치하지 않습니다.';
//       }
//     } else {
//       errorMsg = '비밀번호를 입력해주세요.';
//     }
//
//     if (userPhone != '') {
//       if (!isPhoneNumberFormat(userPhone)) {
//         errorMsg = '전화번호 형식이 아닙니다. 다시 입력해 주세요.';
//       }
//     } else {
//       errorMsg = '전화번호를 입력하지 않았습니다';
//     }
//
//     if(isEmptyString(schoolNm)) {
//       errorMsg = '학교명을 입력하지 않았습니다.';
//     }
//
//     return errorMsg;
//   }
//
//   _kakaoJoinButton() {
//     return Container(
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(CONST_BORDER_RADIUS_CIR25),
//           border: Border.all(
//             color: Colors.yellow.shade700,
//           ),
//           color: Colors.yellow),
//       child: TextButton(
//         onPressed: () {},
//         child: const Text(
//           '카카오톡 계정',
//           style: TextStyle(fontSize: CONST_TEXT_20),
//         ),
//       ),
//     );
//   }
// }
