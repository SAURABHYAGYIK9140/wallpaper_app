import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  late FirebaseFirestore _firestore;
  late FirebaseStorage _storage;
  late FirebaseAuth _auth;

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  void initialize() {
    _firestore = FirebaseFirestore.instance;
    _storage = FirebaseStorage.instance;
    _auth = FirebaseAuth.instance;
  }

  // Firestore reference
  FirebaseFirestore get firestore => _firestore;
  FirebaseStorage get storage => _storage;
  FirebaseAuth get auth => _auth;

  // ============ FIRESTORE READ OPERATIONS ============

  /// Get a single document by ID
  Future<DocumentSnapshot> getDocument(String collection, String docId) async {
    try {
      return await _firestore.collection(collection).doc(docId).get();
    } catch (e) {
      if (kDebugMode) print('Error getting document: $e');
      rethrow;
    }
  }

  /// Get all documents from a collection
  Future<QuerySnapshot> getAllDocuments(String collection) async {
    try {
      return await _firestore.collection(collection).get();
    } catch (e) {
      if (kDebugMode) print('Error getting all documents: $e');
      rethrow;
    }
  }

  /// Get documents with a where condition
  Future<QuerySnapshot> getDocumentsWhere(
    String collection,
    String field,
    dynamic isEqualTo,
  ) async {
    try {
      return await _firestore
          .collection(collection)
          .where(field, isEqualTo: isEqualTo)
          .get();
    } catch (e) {
      if (kDebugMode) print('Error getting filtered documents: $e');
      rethrow;
    }
  }

  /// Get documents with multiple where conditions
  Future<QuerySnapshot> getDocumentsWithMultipleFilters(
    String collection,
    List<Map<String, dynamic>> filters,
  ) async {
    try {
      Query query = _firestore.collection(collection);
      for (var filter in filters) {
        query = query.where(filter['field'], isEqualTo: filter['value']);
      }
      return await query.get();
    } catch (e) {
      if (kDebugMode) print('Error getting multi-filtered documents: $e');
      rethrow;
    }
  }

  /// Get documents with limit
  Future<QuerySnapshot> getDocumentsWithLimit(
    String collection, {
    int limit = 10,
    String? orderBy,
    bool descending = false,
  }) async {
    try {
      Query query = _firestore.collection(collection);
      if (orderBy != null) {
        query = query.orderBy(orderBy, descending: descending);
      }
      query = query.limit(limit);
      return await query.get();
    } catch (e) {
      if (kDebugMode) print('Error getting limited documents: $e');
      rethrow;
    }
  }

  /// Stream collection data (real-time updates)
  Stream<QuerySnapshot> streamCollection(String collection) {
    try {
      return _firestore.collection(collection).snapshots();
    } catch (e) {
      if (kDebugMode) print('Error streaming collection: $e');
      rethrow;
    }
  }

  /// Stream filtered collection data (real-time updates)
  Stream<QuerySnapshot> streamCollectionWhere(
    String collection,
    String field,
    dynamic isEqualTo,
  ) {
    try {
      return _firestore
          .collection(collection)
          .where(field, isEqualTo: isEqualTo)
          .snapshots();
    } catch (e) {
      if (kDebugMode) print('Error streaming filtered collection: $e');
      rethrow;
    }
  }

  // ============ FIRESTORE WRITE OPERATIONS ============

  /// Add a new document with auto-generated ID
  Future<DocumentReference> addDocument(
    String collection,
    Map<String, dynamic> data,
  ) async {
    try {
      return await _firestore.collection(collection).add(data);
    } catch (e) {
      if (kDebugMode) print('Error adding document: $e');
      rethrow;
    }
  }

  /// Set document with specific ID (overwrites if exists)
  Future<void> setDocument(
    String collection,
    String docId,
    Map<String, dynamic> data, {
    bool merge = false,
  }) async {
    try {
      await _firestore.collection(collection).doc(docId).set(data, SetOptions(merge: merge));
    } catch (e) {
      if (kDebugMode) print('Error setting document: $e');
      rethrow;
    }
  }

  /// Update document fields
  Future<void> updateDocument(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore.collection(collection).doc(docId).update(data);
    } catch (e) {
      if (kDebugMode) print('Error updating document: $e');
      rethrow;
    }
  }

  /// Delete a document
  Future<void> deleteDocument(String collection, String docId) async {
    try {
      await _firestore.collection(collection).doc(docId).delete();
    } catch (e) {
      if (kDebugMode) print('Error deleting document: $e');
      rethrow;
    }
  }

  /// Batch write operations
  Future<void> batchWrite(List<Map<String, dynamic>> operations) async {
    try {
      WriteBatch batch = _firestore.batch();
      for (var op in operations) {
        final collection = op['collection'] as String;
        final docId = op['docId'] as String;
        final data = op['data'] as Map<String, dynamic>;
        final type = op['type'] as String; // 'set', 'update', 'delete'

        final docRef = _firestore.collection(collection).doc(docId);
        if (type == 'set') {
          batch.set(docRef, data);
        } else if (type == 'update') {
          batch.update(docRef, data);
        } else if (type == 'delete') {
          batch.delete(docRef);
        }
      }
      await batch.commit();
    } catch (e) {
      if (kDebugMode) print('Error in batch write: $e');
      rethrow;
    }
  }

  // ============ FIREBASE STORAGE OPERATIONS ============

  /// Upload file to Firebase Storage
  Future<String> uploadFile(String path, String fileName) async {
    try {
      final file = File(path);
      final ref = _storage.ref().child(fileName);
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      if (kDebugMode) print('Error uploading file: $e');
      rethrow;
    }
  }

  /// Download file from Firebase Storage
  Future<Uint8List?> downloadFile(String fileName) async {
    try {
      final ref = _storage.ref().child(fileName);
      return await ref.getData();
    } catch (e) {
      if (kDebugMode) print('Error downloading file: $e');
      rethrow;
    }
  }

  /// Get download URL for a file
  Future<String> getFileDownloadUrl(String fileName) async {
    try {
      final ref = _storage.ref().child(fileName);
      return await ref.getDownloadURL();
    } catch (e) {
      if (kDebugMode) print('Error getting download URL: $e');
      rethrow;
    }
  }

  /// Delete file from Firebase Storage
  Future<void> deleteFile(String fileName) async {
    try {
      await _storage.ref().child(fileName).delete();
    } catch (e) {
      if (kDebugMode) print('Error deleting file: $e');
      rethrow;
    }
  }

  // ============ FIREBASE AUTH OPERATIONS ============

  /// Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Check if user is logged in
  bool isUserLoggedIn() {
    return _auth.currentUser != null;
  }

  /// Sign up with email and password
  Future<UserCredential> signUpWithEmail(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      if (kDebugMode) print('Error signing up: $e');
      rethrow;
    }
  }

  /// Sign in with email and password
  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      if (kDebugMode) print('Error signing in: $e');
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      if (kDebugMode) print('Error signing out: $e');
      rethrow;
    }
  }

  /// Stream auth state changes
  Stream<User?> streamAuthStateChanges() {
    return _auth.authStateChanges();
  }
}

