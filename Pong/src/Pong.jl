module Pong 
using Nexa

const PADDLE_WIDTH = 20
const PADDLE_HEIGHT = 100
const BALL_SIZE = 20
const SPEED = 400
const BALL_SPEED = 300

mutable struct Paddle
    x::Int
    y::Int
    width::Int
    height::Int
end

mutable struct Ball
    x::Int
    y::Int
    dx::Float64
    dy::Float64
    size::Int
end

mutable struct Game
    player1::Paddle
    player2::Paddle
    ball::Ball
    score1::Int
    score2::Int
end

my_font = Nexa.load_font("./src/Pixeled.ttf", 25)

function on_run()
    p1 = Paddle(30, 310, PADDLE_WIDTH, PADDLE_HEIGHT)
    p2 = Paddle(1230, 310, PADDLE_WIDTH, PADDLE_HEIGHT)
    ball = Ball(640, 360, BALL_SPEED, BALL_SPEED, BALL_SIZE)

    return Game(p1, p2, ball, 0, 0)
end

function update(dt::Float64, game::Game)
    if Nexa.is_key_down("w")
        game.player1.y -= round(SPEED * dt)
    elseif Nexa.is_key_down("s")
        game.player1.y += round(SPEED * dt)
    end

    if Nexa.is_key_down("up")
        game.player2.y -= round(SPEED * dt)
    elseif Nexa.is_key_down("down")
        game.player2.y += round(SPEED * dt)
    end

    game.ball.x += round(game.ball.dx * dt)
    game.ball.y += round(game.ball.dy * dt)

    if game.ball.y <= 0 || game.ball.y + BALL_SIZE >= Nexa.get_window_height()
        game.ball.dy = -game.ball.dy
    end

    if (game.ball.x <= game.player1.x + PADDLE_WIDTH && game.ball.y > game.player1.y && game.ball.y < game.player1.y + PADDLE_HEIGHT) ||
        (game.ball.x + BALL_SIZE >= game.player2.x && game.ball.y > game.player2.y && game.ball.y < game.player2.y + PADDLE_HEIGHT)
         game.ball.dx = -game.ball.dx
    end

    if game.ball.x < 0
        game.score2 += 1
        game.ball.x, game.ball.y = 640, 360
        game.ball.dx = BALL_SPEED
    elseif game.ball.x > 1280
        game.score1 += 1
        game.ball.x, game.ball.y = 640, 360
        game.ball.dx = -BALL_SPEED
    end
end

function render(ctx::Nexa.Context, game::Game)
    Nexa.clear_screen(ctx, Nexa.BLACK)

    Nexa.render_rect_filled(ctx, game.player1.x, game.player1.y, PADDLE_WIDTH, PADDLE_HEIGHT, Nexa.WHITE)
    Nexa.render_rect_filled(ctx, game.player2.x, game.player2.y, PADDLE_WIDTH, PADDLE_HEIGHT, Nexa.WHITE)

    Nexa.render_circle_filled(ctx, game.ball.x, game.ball.y, BALL_SIZE, Nexa.WHITE)

    Nexa.render_text(ctx, my_font, string(game.score1), Nexa.WHITE, 600, 50)
    Nexa.render_text(ctx, my_font, string(game.score2), Nexa.WHITE, 680, 50)
end


    function run()
        game = on_run()
        Nexa.start(
            () -> game,
            (dt) -> update(dt, game),
            (ctx) -> render(ctx, game),
            "Pong",
            1280,
            720,
            false
        )
    end
    
    julia_main() = run()
end # module