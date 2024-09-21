// ignore_for_file: unnecessary_lambdas, avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

List<Map<String, dynamic>> jsonDataList = [];

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.get) {
    print('Get Method Called');
    return Response.json(body: jsonDataList);
  }

  final body = await context.request.body();
  final data = jsonDecode(body) as Map<String, dynamic>;
  if (context.request.method == HttpMethod.post) {
    print('Post Method is Called');
    if (data['title'] == 'clear' && data['description'] == 'clear') {
      jsonDataList.clear();
      print('Data is Cleared Successfully');
      return Response.json(body: {'message': 'Data Cleared Successfully'});
    } else {
      final itemIndex = jsonDataList.indexWhere(
        (item) =>
            item['title'] == data['title'] &&
            item['description'] == data['description'],
      );
      if (itemIndex != -1) {
        print('Item Already Exists');
        return Response.json(body: {'message': 'Item Already Exists'});
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

        print('The $data is Added');
        return Response.json(body: {'message': 'Item Added Successfully'});
      }
    }
  }

  if (context.request.method == HttpMethod.delete) {
    final itemIndex = jsonDataList.indexWhere(
      (item) =>
          item['title'] == data['title'] &&
          item['description'] == data['description'],
    );
    if (itemIndex == -1) {
      return Response.json(
        body: {'error': 'Item Not Found'},
        statusCode: HttpStatus.notFound,
      );
    } else {
      jsonDataList.removeAt(itemIndex);
      print('The $data is Deleted');
      print(body);
      return Response.json(body: {'message': 'Item Deleted Successfully'});
    }
  }

  if (context.request.method == HttpMethod.put) {
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
      print(body);
      return Response.json(body: {'message': 'Item Updated Successfully'});
    } else {
      return Response.json(
        body: {'error': 'Item Not Found'},
        statusCode: HttpStatus.notFound,
      );
    }
  }

  return Response.json(
    body: {'error': 'Method Not Allowed'},
    statusCode: HttpStatus.methodNotAllowed,
  );
}
