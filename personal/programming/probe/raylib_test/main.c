#include "raylib.h"

int main() {
    InitWindow(1280, 720, "raylib test");

    while (!WindowShouldClose()) {
        BeginDrawing();
        ClearBackground(DARKGRAY);
        DrawText("Hello World!", 200, 200, 21, WHITE);
        EndDrawing();
    }

    CloseWindow();
    return 0;
}
