/* SQL Notebook
 * Copyright (C) 2018 Brian Luft
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
 * documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
 * Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
 * WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
 * OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
 * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#include <assert.h>
#include <string.h>
#include <jansson.h>
#include "NativeJsonElement.h"

struct JsonElement {
    json_t* node;
};

struct JsonObjectIterator {
    json_t* obj;
    void* iter;
};

static JsonElement* element_from_node(json_t* node) {
    JsonElement* element = NULL;

    element = calloc(1, sizeof(JsonElement));
    element->node = node;

    return element;
}

JsonElement* json_element_parse(const char* json, char** error_message, int* error_line, int* error_column) {
    json_error_t error = { 0 };
    json_t* node = NULL;

    node = json_loads(
            /* input */ json,
            /* flags */ 0,
            /* error */ &error);
    if (node == NULL) {
        *error_message = strdup(error.text);
        *error_line = error.line;
        *error_column = error.column;
        return NULL;
    } else {
        *error_message = NULL;
        *error_line = 0;
        *error_column = 0;
        return element_from_node(node);
    }
}

void json_element_dispose_element(JsonElement* element) {
    if (element != NULL) {
        if (element->node != NULL) {
            json_decref(element->node);
        }

        free(element);
    }
}

JsonDataType json_element_get_element_type(JsonElement* element) {
    switch (json_typeof(element->node)) {
        case JSON_OBJECT:
            return JSON_DATA_TYPE_OBJECT;

        case JSON_ARRAY:
            return JSON_DATA_TYPE_ARRAY;

        case JSON_STRING:
            return JSON_DATA_TYPE_STRING;

        case JSON_INTEGER:
            return JSON_DATA_TYPE_INTEGER;

        case JSON_REAL:
            return JSON_DATA_TYPE_REAL;

        case JSON_TRUE:
            return JSON_DATA_TYPE_TRUE;

        case JSON_FALSE:
            return JSON_DATA_TYPE_FALSE;

        case JSON_NULL:
            return JSON_DATA_TYPE_NULL;

        default:
            assert(0);
            return JSON_DATA_TYPE_INVALID;
    }
}

const char* json_element_get_string(JsonElement* string_element) {
    return json_string_value(string_element->node);
}

int64_t json_element_get_integer(JsonElement* integer_element) {
    return json_integer_value(integer_element->node);
}

double json_element_get_real(JsonElement* real_element) {
    return json_real_value(real_element->node);
}

int64_t json_element_get_array_size(JsonElement* array_element) {
    return json_array_size(array_element->node);
}

JsonElement* json_element_get_array_item(JsonElement* array_element, int64_t array_index) {
    json_t* child = NULL;

    child = json_array_get(array_element->node, array_index);
    if (child == NULL) {
        assert(0);
        return NULL;
    } else {
        json_incref(child);
        return element_from_node(child);
    }
}

int64_t json_element_get_object_size(JsonElement* object_element) {
    return json_object_size(object_element->node);
}

JsonObjectIterator* json_element_get_object_iterator(JsonElement* object_element) {
    JsonObjectIterator* object_iterator = calloc(1, sizeof(JsonObjectIterator));
    object_iterator->obj = object_element->node;
    json_incref(object_iterator->obj);
    object_iterator->iter = json_object_iter(object_element->node);
    return object_iterator;
}

void json_element_dispose_object_iterator(JsonObjectIterator* object_iterator) {
    if (object_iterator != NULL) {
        if (object_iterator->obj != NULL) {
            json_decref(object_iterator->obj);
        }

        free(object_iterator);
    }
}

void json_element_object_iterator_next(JsonObjectIterator* object_iterator) {
    if (object_iterator->iter != NULL) {
        object_iterator->iter = json_object_iter_next(object_iterator->obj, object_iterator->iter);
    }
}

int json_element_object_iterator_eof(JsonObjectIterator* object_iterator) {
    return object_iterator->iter == NULL;
}

const char* json_element_object_iterator_key(JsonObjectIterator* object_iterator) {
    return json_object_iter_key(object_iterator->iter);
}

JsonElement* json_element_object_iterator_value(JsonObjectIterator* object_iterator) {
    json_t* node = NULL;

    node = json_object_iter_value(object_iterator->iter);
    json_incref(node);
    return element_from_node(node);
}

JsonElement* json_element_for_true() {
    return element_from_node(json_true());
}

JsonElement* json_element_for_false() {
    return element_from_node(json_false());
}

JsonElement* json_element_for_null() {
    return element_from_node(json_null());
}

JsonElement* json_element_for_string(const char* value) {
    return element_from_node(json_string(value));
}

JsonElement* json_element_for_integer(int64_t value) {
    return element_from_node(json_integer(value));
}

JsonElement* json_element_for_real(double value) {
    return element_from_node(json_real(value));
}

JsonElement* json_element_for_array() {
    return element_from_node(json_array());
}

void json_element_array_append(JsonElement* array_element, JsonElement* child_element) {
    json_array_append(array_element->node, child_element->node);
}

JsonElement* json_element_for_object() {
    return element_from_node(json_object());
}

void json_element_object_set(JsonElement* object_element, const char* key, JsonElement* value_element) {
    json_object_set(object_element->node, key, value_element->node);
}

char* json_element_to_json_string(JsonElement* element) {
    return json_dumps(element->node, JSON_COMPACT | JSON_ENCODE_ANY);
}
