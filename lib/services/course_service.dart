import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edustore/models/course_model.dart';
import 'package:edustore/services/google_drive_service.dart';
import 'package:edustore/utils/app_exception.dart';
import 'package:mime/mime.dart';

class CourseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleDriveService _driveService = GoogleDriveService();

  Future<List<CourseModel>> getAllCourses() async {
    try {
      final querySnapshot = await _firestore.collection('courses').get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return CourseModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw AppException('Erreur lors du chargement des cours: $e');
    }
  }

  Future<List<CourseModel>> getCoursesByPage(int page, int pageSize) async {
    try {
      final querySnapshot = await _firestore
          .collection('courses')
          .orderBy('createdAt')
          .limit(pageSize * page)
          .get();

      final docs = querySnapshot.docs.skip(pageSize * (page - 1));
      return docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return CourseModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw AppException('Erreur lors du chargement des cours paginés: $e');
    }
  }

  Future<CourseModel> createCourse(
    CourseModel course, {
    File? file,
    Uint8List? fileBytes,
  }) async {
    try {
      String? fileUrl;

      if (file != null || fileBytes != null) {
        final filename = DateTime.now().millisecondsSinceEpoch.toString();
        final mime = lookupMimeType(file?.path ?? '', headerBytes: fileBytes);

        fileUrl = await _driveService.uploadToDrive(
          filename: filename,
          file: file,
          fileBytes: fileBytes,
          mimeType: mime ?? 'application/octet-stream',
        );
      }

      final data = course.toJson();
      if (fileUrl != null) {
        data['image'] = fileUrl;
      }

      final docRef = await _firestore.collection('courses').add(data);
      final docSnap = await docRef.get();

      return CourseModel.fromJson(docSnap.data()!..['id'] = docSnap.id);
    } catch (e) {
      throw AppException('Erreur lors de la création du cours: $e');
    }
  }

  Future<void> updateCourse(CourseModel course) async {
    try {
      final data = course.toJson();
      data.remove('id');
      await _firestore.collection('courses').doc(course.id).update(data);
    } catch (e) {
      throw AppException('Erreur lors de la mise à jour du cours: $e');
    }
  }

  Future<void> deleteCourse(String courseId) async {
    try {
      await _firestore.collection('courses').doc(courseId).delete();
    } catch (e) {
      throw AppException('Erreur lors de la suppression du cours: $e');
    }
  }
}
