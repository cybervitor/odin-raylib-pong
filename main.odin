package game

import m "core:math"
import rl "vendor:raylib"

WINDOW_WIDTH: i32 = 1280
WINDOW_HEIGHT: i32 = 720

BACKGROUND_COLOR := rl.Color{160, 200, 255, 255}

BALL_COLOR := rl.Color{0, 0, 255, 255}
BALL_SIZE: f32 = 20


main :: proc() {
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Odin + Raylib Pong Clone")
	rl.SetTargetFPS(60) //Limit to 60FPS t        "panel": "shared",

	ball_pos: rl.Vector2
	mouse_pos: rl.Vector2

	//Main Loop
	for !rl.WindowShouldClose() {

		// Update Phase
		ball_pos = rl.GetMousePosition()
		//ball_pos.x = i32(m.sin_f16(1))


		rl.BeginDrawing() // Render Phase
		rl.ClearBackground(BACKGROUND_COLOR)
		drawBall(ball_pos, BALL_COLOR)
		rl.EndDrawing()


	}

	rl.CloseWindow()
}

drawBall :: proc(ball_position: rl.Vector2, ball_color: rl.Color) {
	rl.DrawCircleV(ball_position, BALL_SIZE, ball_color)
}
