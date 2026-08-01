Color :: struct {
  r : u8;
  g : u8;
  b : u8;
  a : u8;
};

Vector2 :: struct {
  x : float;
  y : float;
};

;; Initialize window and OpenGL context
external InitWindow : void(
  width : int, height : int, title : byte.ptr
);
external SetTargetFPS : void(fps : cint);
external SetConfigFlags : void(flags : cuint);
external WindowShouldClose : bool();
external BeginDrawing : void();
external ClearBackground : void(color : Color);
;; Draw triangle outline (vertex in counter-clockwise order!)
external DrawTriangleLines : void(v1 : Vector2, v2 : Vector2, v3 : Vector2, color : Color);
external EndDrawing : void();
external CloseWindow : void();
external EnableEventWaiting : void();

midpoint : Vector2(
  a : Vector2,
  b : Vector2
) {
  out : Vector2 !{
    a.x + b.x,
    a.y + b.y
  };
  out.x /= 2.0;
  out.y /= 2.0;
  out;
};

sierpinski : void(
  a : Vector2, b : Vector2, c : Vector2,
  steps : uint
) {
  color : Color !{ 255, 255, 255, 255 };
  DrawTriangleLines a, b, c, color;

  if not steps, return;
  steps -= 1;

  mid_ab :: midpoint a, b;
  mid_ac :: midpoint a, c;
  mid_bc :: midpoint b, c;

  sierpinski a, mid_ab, mid_ac, steps;
  sierpinski mid_ab, b, mid_bc, steps;
  sierpinski mid_ac, mid_bc, c, steps;
};

sierpinski_top : void(steps : uint) {
  a : Vector2 !{0.0, 480.0};
  b : Vector2 !{480.0, 480.0};
  c : Vector2 !{240.0, 0.0};
  sierpinski a, b, c, steps;
};

x :: 1;
max :: 8;
a : Vector2 !{0.0, 480.0};
b : Vector2 !{480.0, 480.0};
c : Vector2 !{240.0, 0.0};
bg : Color !{0, 0, 0, 255};
fg : Color !{255, 255, 255, 255};

InitWindow 640, 480, "GlintUI.Raylib"[0];
SetTargetFPS 10;
print "[GLINT]: Window initialized\n";
while not WindowShouldClose, {
  BeginDrawing;
  ClearBackground bg;

  x += 1;
  if x > max,
    x := 1;

  ;; DrawTriangleLines a, b, c, fg;
  sierpinski_top x;

  ;; Actually display rendered data.
  EndDrawing;
};

CloseWindow;
