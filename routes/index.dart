// ignore_for_file: unnecessary_lambdas, avoid_print

// I hope this project is helpful to you
// Please follow me on GitHub:
// AminKhanZadeh1

// There are 2 entities named title and description in the project

// You can change them or add new ones if you want

import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

List<Map<String, dynamic>> jsonDataList = [];

Future<Response> onRequest(RequestContext context) async {
  //

  //

  // GET
  if (context.request.method == HttpMethod.get) {
    print('GET method called');
    return Response.json(body: jsonDataList);
  }

  final body = await context.request.body();
  final data = jsonDecode(body) as Map<String, dynamic>;

  //

  //

  // POST
  if (context.request.method == HttpMethod.post) {
    print('POST method called');
    if (data['title'] == 'clear' && data['description'] == 'clear') {
      jsonDataList.clear();
      print('Json list cleared');
      return Response.json(
        body: {'message': 'Data cleared successfully'},
      );
    } else {
      final itemIndex = jsonDataList.indexWhere(
        (item) =>
            item['title'] == data['title'] &&
            item['description'] == data['description'],
      );
      if (itemIndex != -1) {
        print('Item already exists');
        return Response.json(body: {'message': 'Item already exists'});
      } else {
        if (jsonDataList.isEmpty) {
          const id = 0;
          jsonDataList.add(
            {
              'id': id,
              'title': data['title'] as String,
              'description': data['description'] as String,
            } as Map<String, dynamic>,
          );
        } else {
          final id = jsonDataList.indexed.last.$2['id'] as int;
          jsonDataList.add(
            {
              'id': id + 1,
              'title': data['title'] as String,
              'description': data['description'] as String,
            } as Map<String, dynamic>,
          );
        }

        print('The $data added');
        return Response.json(
          body: {'message': 'Item added successfully'},
        );
      }
    }
  }
  //

  //

  // DELETE
  if (context.request.method == HttpMethod.delete) {
    print('DELETE method called');
    final itemIndex = jsonDataList.indexWhere(
      (item) =>
          item['title'] == data['title'] &&
          item['description'] == data['description'],
    );
    if (itemIndex == -1) {
      print('Item is not found');
      return Response.json(
        body: {'error': 'Item is not found'},
        statusCode: HttpStatus.notFound,
      );
    } else {
      jsonDataList.removeAt(itemIndex);
      print('The $data deleted');
      print('Body: $body');
      return Response.json(
        body: {'message': 'Item is deleted successfully'},
      );
    }
  }
  //

  //

  // PUT
  if (context.request.method == HttpMethod.put) {
    print('PUT method called');
    final title = data['title'] as String;
    final description = data['description'] as String;

    // Find the index of the item with the given id
    final itemIndex = jsonDataList.indexWhere(
      (item) => item['title'] == title && item['description'] == description,
    );

// Check if the item exists
    if (itemIndex != -1) {
      jsonDataList[itemIndex]['title'] = title;
      jsonDataList[itemIndex]['description'] = description;
      print('Item updated successfully');
      print('Body: $body');
      return Response.json(
        body: {'message': 'Item updated successfully'},
      );
    } else {
      print('Item not found');
      return Response.json(
        body: {'error': 'Item not found'},
        statusCode: HttpStatus.notFound,
      );
    }
  }

  return Response.json(
    body: {'error': 'Method not allowed'},
    statusCode: HttpStatus.methodNotAllowed,
  );
}
