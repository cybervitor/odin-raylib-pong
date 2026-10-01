package game

import m "core:math"
import rl "vendor:raylib"

Ball :: struct {
	position:  rl.Vector2,
	direction: rl.Vector2,
	size:      f32,
	color:     rl.Color,
}

Paddle :: struct {
	position: rl.Vector2,
	size:     rl.Vector2,
	color:    rl.Color,
}

WINDOW_WIDTH: f32 = 1280
WINDOW_HEIGHT: f32 = 720
BACKGROUND_COLOR := rl.Color{160, 200, 255, 255}

SCORE_ZONE_SIZE: f32 = 20
SCORE_ZONE_COLOR := rl.Color{255, 255, 255, 150}
SCORE_ZONE_LEFT := rl.Vector2{0, 0}
SCORE_ZONE_RIGHT := rl.Vector2{WINDOW_WIDTH - SCORE_ZONE_SIZE, 0}

BALL_BASE_COLOR := rl.Color{0, 0, 255, 255}
BALL_BASE_SIZE: f32 = 10
BALL_BASE_SPEED: f32 = 5
BALL_STARTING_POSITION := rl.Vector2{WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2}

PADDLE_BASE_WIDTH: f32 = 20
PADDLE_BASE_HEIGHT: f32 = 150
PADDLE_BASE_SIZE := rl.Vector2{PADDLE_BASE_WIDTH, PADDLE_BASE_HEIGHT}
PADDLE_BASE_SPEED: f32 = 200
PADDLE_BASE_COLOR := rl.Color{0, 0, 0, 255}
SPACE_BETWEEN_SCORE_ZONE_AND_PADDLE: f32 = 15

LEFT_PADDLE_STARTING_POSITION := rl.Vector2 {
	0 + SCORE_ZONE_SIZE + SPACE_BETWEEN_SCORE_ZONE_AND_PADDLE,
	(WINDOW_HEIGHT - PADDLE_BASE_HEIGHT) / 2, //Must subtract PADDLE_BASE_HEIGHT because 2d graphics are drawn starting from the top left to the bottom right
}
RIGHT_PADDLE_STARTING_POSITION := rl.Vector2 { 	//Must subtract PADDLE_BASE_WIDTH because 2d graphics are drawn starting from the top left to the bottom right
	WINDOW_WIDTH - SCORE_ZONE_SIZE - SPACE_BETWEEN_SCORE_ZONE_AND_PADDLE - PADDLE_BASE_WIDTH,
	(WINDOW_HEIGHT - PADDLE_BASE_HEIGHT) / 2,
}

main :: proc() {
	rl.InitWindow(i32(WINDOW_WIDTH), i32(WINDOW_HEIGHT), "Odin + Raylib Pong Clone")
	rl.SetTargetFPS(60) //Limit to 60FPS to have the same behaviour all the time
	dt: f32
	//Starting variables
	ball := Ball {
		BALL_STARTING_POSITION,
		rl.Vector2 {
			f32(rl.GetRandomValue(-1, 1)) * BALL_BASE_SPEED,
			f32(rl.GetRandomValue(-1, 1)) * BALL_BASE_SPEED,
		},
		BALL_BASE_SIZE,
		BALL_BASE_COLOR,
	}
	left_paddle := Paddle{LEFT_PADDLE_STARTING_POSITION, PADDLE_BASE_SIZE, PADDLE_BASE_COLOR}
	right_paddle := Paddle{RIGHT_PADDLE_STARTING_POSITION, PADDLE_BASE_SIZE, PADDLE_BASE_COLOR}

	//Main Loop
	for !rl.WindowShouldClose() {
		dt = rl.GetFrameTime()

		// Update Phase

		paddleController(&left_paddle, dt)
		ballController(&ball, dt)
		//ball_pos.x = i32(m.sin_f16(1))

		// Render Phase
		rl.BeginDrawing()
		rl.ClearBackground(BACKGROUND_COLOR)
		drawBall(ball)
		drawPaddle(left_paddle)
		drawPaddle(right_paddle)
		drawScoreZones()
		rl.EndDrawing()

	}

	rl.CloseWindow()
}

ballController :: proc(b: ^Ball, dt: f32) {
	b.position = b.position + b.direction
}

paddleController :: proc(p: ^Paddle, dt: f32) {
	if rl.IsKeyDown(rl.KeyboardKey.UP) {
		p.position.y -= PADDLE_BASE_SPEED * dt
	} else if rl.IsKeyDown(rl.KeyboardKey.DOWN) {
		p.position.y += PADDLE_BASE_SPEED * dt
	}
	p.position.y = clamp(p.position.y, 0, WINDOW_HEIGHT - p.size.y)
}

drawScoreZones :: proc() {
	rl.DrawRectangleV(
		SCORE_ZONE_LEFT,
		rl.Vector2{SCORE_ZONE_SIZE, WINDOW_HEIGHT},
		SCORE_ZONE_COLOR,
	)
	rl.DrawRectangleV(
		SCORE_ZONE_RIGHT,
		rl.Vector2{SCORE_ZONE_SIZE, WINDOW_HEIGHT},
		SCORE_ZONE_COLOR,
	)

}

drawPaddle :: proc(p: Paddle) {
	rl.DrawRectangleV(p.position, p.size, p.color)
}

drawBall :: proc(b: Ball) {
	rl.DrawCircleV(b.position, b.size, b.color)
}
