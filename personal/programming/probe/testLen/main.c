// Code fully rip from nob.h by Tsoding (https://github.com/tsoding/nob.h/blob/main/nob.h)
// Only made as a self-taught way to learn about dynamic arrays in C.
// It's merely a start of a representation on how you can use them.
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#define N 20
#define ARRAY_LEN(array) (sizeof(array)/sizeof(array[0]))

typedef struct {
    int *items;
    size_t count;
    size_t capacity;
} DA_int;

#define PRINTF_FORMAT(STRING_INDEX, FIRST_TO_CHECK) __attribute__ ((format (printf, STRING_INDEX, FIRST_TO_CHECK)))
#define UNUSED(var) (void)(var)
#define UNREACHABLE(message) do { fprintf(stderr, message); } while(0)

typedef enum {
    INFO,
    WARNING,
    ERROR,
    NO_LOGS,
} Log_Level;

void log_message(Log_Level level, const char *fmt, ...) PRINTF_FORMAT(2, 3);

void log_message(Log_Level level, const char *fmt, ...) {
    switch (level) {
        case INFO:
            fprintf(stderr, "[INFO] ");
            break;
        case WARNING:
            fprintf(stderr, "[WARNING] ");
            break;
        case ERROR:
            fprintf(stderr, "[ERROR] ");
            break;
        case NO_LOGS:
            return;
        default:
            UNREACHABLE("log_message");
    }
    va_list args;
    va_start(args, fmt);
    vfprintf(stderr, fmt, args);
    va_end(args);
    fprintf(stderr, "\n");
}

#define DA_INIT_CAP 256
#define da_reserve_mem(da, expected_capacity)                                                       \
    do {                                                                                            \
        if ((expected_capacity) > (da)->capacity) {                                                 \
            if ((da)->capacity == 0) {                                                              \
                (da)->capacity = DA_INIT_CAP;                                                       \
            }                                                                                       \
            while ((expected_capacity) > (da)->capacity) {                                          \
                (da)->capacity *= 2;                                                                \
            }                                                                                       \
            (da)->items = realloc((da)->items, (da)->capacity * sizeof(*(da)->items)); \
            assert((da)->items != NULL && "Buy more RAM lol");                                      \
        }                                                                                           \
    } while(0)

#define da_append(da, item) \
    do { \
        da_reserve_mem((da), (da)->count + 1); \
        (da)->items[ (da)->count++ ] = (item); \
    } while(0)

#define da_free(da) free((da).items);

#define da_append_loads(da, new_items, new_items_count) \
    do { \
        da_reserve_mem((da), (da)->count + (new_items_count)); \
        memcpy((da)->items + (da)->count, (new_items), (new_items_count)*sizeof( *(da)->items )); \
        (da)->count += (new_items_count); \
    } while(0)

#define da_resize(da, new_size) \
    do { \
        da_reserve_mem((da), new_size); \
        (da)->count = new_size; \
    } while(0)

#define da_head(da) (da)->items[ (assert((da)->count > 0), (da)->count-1) ]

// To remove an item, it swaps the last at the i-th position and decrement the array
// Since each items is in an array allocated on the heap, it doesn't matter, as it just forgo the item entierely.
#define da_remove_unorderly(da, i) \
    do { \
        size_t j = (i); \
        assert( j < (da)->count ); \
        (da)->items[j] = (da)->items[--(da)->count]; \
    } while(0)

#define da_foreach(da, it, Type) for (Type *it = (da)->items; it < (da)->items + (da)->count; ++it)

#define da_int_append(da, ...) \
    da_append_loads(da, ((int[]){__VA_ARGS__}), (sizeof((int[]){__VA_ARGS__})/sizeof(int)))

#define da_int_print(da) \
    do { \
        da_foreach(da, it, int) { \
            fprintf(stderr, "%d ", *it); \
        } \
        printf("\n"); \
    } while(0)

int main() {
    DA_int arr = {0};
    da_int_append(&arr, 3, 2, 8);

    log_message(INFO, "arr size: %zu", arr.count);
    log_message(INFO, "arr capacity: %zu", arr.capacity);
    log_message(INFO, "array items:");
    da_int_print(&arr);

    log_message(INFO, "Head of the array: %d", da_head(&arr));
    da_int_append(&arr, 3, 0, 1, 3);
    da_int_print(&arr);
    log_message(INFO, "Head of the array: %d", da_head(&arr));

    while (arr.count > 1) {
        da_remove_unorderly(&arr, 0);
        da_int_print(&arr);
        log_message(INFO, "Head of the array: %d", da_head(&arr));
    }
    return 0;
}
