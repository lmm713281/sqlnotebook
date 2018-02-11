// SQL Notebook
// Copyright (C) 2018 Brian Luft
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
// Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
// WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
// OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#pragma once

#include <stdint.h>
#include "NativeJsonDataType.h"

typedef struct JsonElement JsonElement;
typedef struct JsonObjectIterator JsonObjectIterator;

JsonElement* json_element_parse(const char* json, char** error_message, int* error_line, int* error_column);
void json_element_dispose_element(JsonElement* element);
JsonDataType json_element_get_element_type(JsonElement* element);
const char* json_element_get_string(JsonElement* string_element);
int64_t json_element_get_integer(JsonElement* integer_element);
double json_element_get_real(JsonElement* real_element);
int64_t json_element_get_array_size(JsonElement* array_element);
JsonElement* json_element_get_array_item(JsonElement* array_element, int64_t array_index);
int64_t json_element_get_object_size(JsonElement* object_element);
JsonObjectIterator* json_element_get_object_iterator(JsonElement* object_element);
void json_element_dispose_object_iterator(JsonObjectIterator* object_iterator);
void json_element_object_iterator_next(JsonObjectIterator* object_iterator);
int json_element_object_iterator_eof(JsonObjectIterator* object_iterator);
const char* json_element_object_iterator_key(JsonObjectIterator* object_iterator);
JsonElement* json_element_object_iterator_value(JsonObjectIterator* object_iterator);
JsonElement* json_element_for_true();
JsonElement* json_element_for_false();
JsonElement* json_element_for_null();
JsonElement* json_element_for_string(const char* value);
JsonElement* json_element_for_integer(int64_t value);
JsonElement* json_element_for_real(double value);
JsonElement* json_element_for_array();
void json_element_array_append(JsonElement* array_element, JsonElement* child_element);
JsonElement* json_element_for_object();
void json_element_object_set(JsonElement* object_element, const char* key, JsonElement* value_element);
char* json_element_to_json_string(JsonElement* element);
