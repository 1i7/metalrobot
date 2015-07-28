use <../gears/gears.scad>;

print_error=0.2;

// половинка с мотором
box_half_motor(print_error=print_error);

// половинка с колесами
//box_half_wheels(print_error=print_error);

// в сборке
//gearbox();

//motor_fix();

gear_transmission1_x=15.9;
gear_transmission1_y=5.2;

gear_transmission2_x=27.5;
gear_transmission2_y=17.5;

gear_wheel_x=35;
gear_wheel_y=2.3;

// левый/правый верхний
hole1_x=48;
hole1_y=11.6;
// левый/правый нижний
hole2_x=48;
hole2_y=-6.9;

// по центру
hole_center1_y=17.5;


/**
 * Редуктор в сборке.
 */
module gearbox() {
  // значения высоты для разных деталей
  wheels_half_height = 4;
  //motor_half_height = 4;

  gear_motor_height = 5;

  gear_transmission1_height1 = 0.3+3;
  gear_transmission1_height2 = 5;
  gear_transmission1_height = 
    gear_transmission1_height1+gear_transmission1_height2;

  gear_transmission2_height1 = 0.3+3;
  gear_transmission2_height2 = 5;
  gear_transmission2_height = 
    gear_transmission2_height1+gear_transmission2_height2;

  gear_wheel_height = 0.3+3;

  // стенки
  box_half_wheels();
  /*translate([0, 0, 
    wheels_half_height // высота стенки с колесами
      +0.5 // отступ от стенки
      +gear_transmission1_height1 // ступень 1 передачи 1
      +0.5 // отступ
      +gear_transmission2_height // высота передачи 2
      +0.5]) // отступ
        box_half_motor();
  */
  // шестерни (см координаты в gearbox5-dev.svg в Inkscape)

  // шестерня на вал мотора
  translate([0, 0, wheels_half_height + 0.1])
    gear_motor(print_error=0.2); // diam=2.4

  // передача 1: от мотора к передаче 2
  // слева
  translate([-gear_transmission1_x, gear_transmission1_y, 
      0.3+wheels_half_height+0.5+0.1])
    gear_transmission1(print_error=0.2);
  // справа
  translate([gear_transmission1_x, gear_transmission1_y, 
      0.3+wheels_half_height+0.5+0.1])
    gear_transmission1(print_error=0.2);

  // передача 2: от передачи 1 к колесу
  // слева
  translate([-gear_transmission2_x, gear_transmission2_y, 
      0.3+wheels_half_height+0.5+gear_transmission1_height1+0.5+0.1])
    gear_transmission2(print_error=0.2);
  // справа
  translate([gear_transmission2_x, gear_transmission2_y, 
      0.3+wheels_half_height+0.5+gear_transmission1_height1+0.5+0.1])
    gear_transmission2(print_error=0.2);

  // шестерня на колесо
  // слева
  translate([-gear_wheel_x, gear_wheel_y, 
    0.3 // вернуть шестерню на 0ю позицию
      +wheels_half_height // стенка редуктора
      +0.5 // отступ снизу до шестерни 1й передачи
      +gear_transmission1_height1 // первая шестерня передачи 1
      +0.5 // отступ от первой шестени передачи 1
      +gear_transmission2_height1 // первая шестерня передачи 2
      +0.5 // отступ от первой шестерни передачи 2
      +0.1 // свободное пространство
    ])
        gear_wheel(print_error=0.1);
  // справа
  translate([gear_wheel_x, gear_wheel_y, 
    0.3 // вернуть шестерню на 0ю позицию
      +wheels_half_height // стенка редуктора
      +0.5 // отступ снизу до шестерни 1й передачи
      +gear_transmission1_height1 // первая шестерня передачи 1
      +0.5 // отступ от первой шестени передачи 1
      +gear_transmission2_height1 // первая шестерня передачи 2
      +0.5 // отступ от первой шестерни передачи 2
      +0.1 // свободное пространство
    ])
      gear_wheel(print_error=0.1);
}



/**
 * Половина коробки со стороны мотора.
 */
module box_half_motor(print_error=0) {
// значения высоты для разных деталей
  motor_half_height = 4;

  gear_transmission1_height1 = 0.3+3;
  gear_transmission1_height2 = 5;
  gear_transmission1_height = 
    gear_transmission1_height1+gear_transmission1_height2;

  gear_transmission2_height1 = 0.3+3;
  gear_transmission2_height2 = 5;
  gear_transmission2_height = 
    gear_transmission2_height1+gear_transmission2_height2;

  // для "рассверливания" дырок
  max_height=motor_half_height+gear_transmission1_height1+gear_transmission2_height1;

  screw_bar_r = 3.5;
  

  // (см координаты винтов и шестеренок в gearbox5-dev.svg в Inkscape)
  difference() {
    union() {
      // внутренняя поверхность
      linear_extrude(height=3) 
        import(file="box-motor-inside-43d.dxf");

      // внешняя стенка
      translate([0, 0, 2.9]) linear_extrude(height=1.1)
        import(file="box-motor-wall-43d.dxf");

      // крепление мотора
      translate([0, 0, 3.9]) motor_fix();
    }

    // "рассверлить" дырки для учета погрешности при печати на 3д-принтере,
    // добавить углубления стоек

    // для винтов
    // левый верхний
    translate([-hole1_x, hole1_y, -1])
      cylinder(r=1.5+print_error, h=max_height+2, $fn=100);
    // для стойки
    translate([-hole1_x, hole1_y, -1])
      cylinder(r=screw_bar_r+print_error, h=3, $fn=100);
    // левый нижний
    translate([-hole2_x, hole2_y, -1])
      cylinder(r=1.5+print_error, h=max_height+2, $fn=100);
    // для стойки
    translate([-hole2_x, hole2_y, -1])
      cylinder(r=screw_bar_r+print_error, h=3, $fn=100);

    // правый верхний
    translate([hole1_x, hole1_y, -1])
      cylinder(r=1.5+print_error, h=max_height+2, $fn=100);
    // для стойки
    translate([hole1_x, hole1_y, -1])
      cylinder(r=screw_bar_r+print_error, h=3, $fn=100);
    // правый нижний
    translate([hole2_x, hole2_y, -1])
      cylinder(r=1.5+print_error, h=max_height+2, $fn=100);
    // для стойки
    translate([hole2_x, hole2_y, -1])
      cylinder(r=screw_bar_r+print_error, h=3, $fn=100);

    // винт по центру
    translate([0, hole_center1_y, -1])
      cylinder(r=1.5+print_error, h=max_height+2, $fn=100);
    // для стойки
    translate([0, hole_center1_y, -1])
      cylinder(r=screw_bar_r+print_error, h=3, $fn=100);


    // для шестеренок на передачах 1
    // слева
    translate([-gear_transmission1_x, gear_transmission1_y, -1])
      cylinder(r=1+print_error, h=4, $fn=100);
    // справа
    translate([gear_transmission1_x, gear_transmission1_y, -1])
      cylinder(r=1+print_error, h=4, $fn=100);

    // для шестеренок на передачах 2
    // слева
    translate([-gear_transmission2_x, gear_transmission2_y, -1])
      cylinder(r=1+print_error, h=4, $fn=100);
    // справа
    translate([gear_transmission2_x, gear_transmission2_y, -1])
      cylinder(r=1+print_error, h=4, $fn=100);

    // для шестеренок на колесах 
    // слева
    translate([-gear_wheel_x, gear_wheel_y, -1])
      cylinder(r=1.5+print_error, h=4, $fn=100);
    // справа
    translate([gear_wheel_x, gear_wheel_y, -1])
      cylinder(r=1.5+print_error, h=4, $fn=100);
  }
}

/**
 * Половина коробки со стороны колёс.
 */
module box_half_wheels(print_error=0) {
  // значения высоты для разных деталей
  wheels_half_height = 4;

  // шестеренки
  gear_motor_height = 3;

  gear_transmission1_height1 = 0.3+3;
  gear_transmission1_height2 = 5;
  gear_transmission1_height = 
    gear_transmission1_height1+gear_transmission1_height2;

  gear_transmission2_height1 = 0.3+3;
  gear_transmission2_height2 = 5;
  gear_transmission2_height = 
    gear_transmission2_height1+gear_transmission2_height2;

  gear_wheel_height = 0.3+3;

  // высота стоек между половинками коробки (с учетом утопления)
  screw_bar_height = 
    0.5+gear_transmission1_height1+0.5+gear_transmission2_height+2;
  screw_head_radius = 3.5;

  // для "рассверливания" дырок
  max_height=wheels_half_height
    +gear_transmission1_height1+gear_transmission2_height1+3;

  // (см координаты винтов и шестеренок в gearbox5-dev.svg в Inkscape)
  difference() {
    union() {
      // внешняя стенка
      linear_extrude(height=1.1)
        import(file="box-wheels-wall-43d.dxf");

      // внутренняя поверхность
      translate([0, 0, 1]) linear_extrude(height=3) 
        import(file="box-wheels-inside-43d.dxf");

      // стойки для винтов и шестеренок

      // для винтов
      // левый верхний
      translate([-hole1_x, hole1_y, wheels_half_height-0.1])
        box_column(height=0.1+screw_bar_height);
      // левый нижний
      translate([-hole2_x, hole2_y, wheels_half_height-0.1])
        box_column(height=0.1+screw_bar_height);

      // правый верхний
      translate([hole1_x, hole1_y, wheels_half_height-0.1])
        box_column(height=0.1+screw_bar_height);
      // правый нижний
      translate([hole2_x, hole2_y, wheels_half_height-0.1])
        box_column(height=0.1+screw_bar_height);

      // винт по центру
      translate([0, hole_center1_y, wheels_half_height-0.1])
        box_column(height=0.1+screw_bar_height);


      // стойки для шестеренок на передаче 1
      // слева
      translate([-gear_transmission1_x, gear_transmission1_y, 
          wheels_half_height-0.1])
        box_column(r2=1, height=1+0.1);
      // справа
      translate([gear_transmission1_x, gear_transmission1_y, wheels_half_height-0.1])
        box_column(r2=1, height=1+0.1);

      // стойки для шестеренок на передаче 2
      // слева
      translate([-gear_transmission2_x, gear_transmission2_y, 
          wheels_half_height-0.1])
        box_column(r2=1, height=0.5+gear_transmission1_height1+1+0.1);
      // справа
      translate([gear_transmission2_x, gear_transmission2_y, 
          wheels_half_height-0.1])
        box_column(r2=1, height=0.5+gear_transmission1_height1+1+0.1);

      // стойки для шестеренок на колесах
      // слева
      translate([-gear_wheel_x, gear_wheel_y, wheels_half_height-0.1])
        box_column(height=
          0.5 // отступ от стенки до передачи 1
          +gear_transmission1_height1 // первая шестеренка передачи 1
          +0.5 // отступ от первой шестеренки передачи 1
          +gear_transmission2_height1 // первая шестеренка передачи 2
          +0.5 // отступ от первой шестеренки передачи 2
          +0.1 // утопить
        );
      // справа
      translate([gear_wheel_x, gear_wheel_y, wheels_half_height-0.1])
        box_column(height=
          0.5 // отступ от стенки до передачи 1
          +gear_transmission1_height1 // первая шестеренка передачи 1
          +0.5 // отступ от первой шестеренки передачи 1
          +gear_transmission2_height1 // первая шестеренка передачи 2
          +0.5 // отступ от первой шестеренки передачи 2
          +0.1 // утопить
        );
    }

    // "рассверлить" дырки для учета погрешности при печати на 3д-принтере,
    // добавить углубления для головок винтов, 
    // убедиться, что стойки не мешают шестеренкам

    // для винтов
    // левый верхний
    translate([-hole1_x, hole1_y, -1])
      cylinder(r=1.5+print_error, h=max_height+2, $fn=100);
    // головка винта
    translate([-hole1_x, hole1_y, -2])
      cylinder(r=screw_head_radius+print_error, h=3, $fn=100);
    // левый нижний
    translate([-hole2_x, hole2_y, -1])
      cylinder(r=1.5+print_error, h=max_height+2, $fn=100);
    // головка винта
    translate([-hole2_x, hole2_y, -2])
      cylinder(r=screw_head_radius+print_error, h=3, $fn=100);

    // правый верхний
    translate([hole1_x, hole1_y, -1])
      cylinder(r=1.5+print_error, h=max_height+2, $fn=100);
    // головка винта
    translate([hole1_x, hole1_y, -2])
      cylinder(r=screw_head_radius+print_error, h=3, $fn=100);
    // правый нижний
    translate([hole2_x, hole2_y, -1])
      cylinder(r=1.5+print_error, h=max_height+2, $fn=100);
    // головка винта
    translate([hole2_x, hole2_y, -2])
      cylinder(r=screw_head_radius+print_error, h=3, $fn=100);

    // винт по центру
    translate([0, hole_center1_y, -1])
      cylinder(r=1.5+print_error, h=max_height+2, $fn=100);
    // головка винта
    translate([0, hole_center1_y, -2])
      cylinder(r=screw_head_radius+print_error, h=3, $fn=100);
   
    // для шестеренок на передаче 1
    // слева
    translate([-gear_transmission1_x, gear_transmission1_y, 1])
      cylinder(r=1+print_error, h=max_height+2, $fn=100);
    // подрезать близлежащие стойки, если есть
    translate([-gear_transmission1_x, gear_transmission1_y, wheels_half_height])
      difference() {
        cylinder(r=16, h=max_height, $fn=100);
        // только не срезать текущую стойку
        cylinder(r=3.6, h=max_height);
      }
    // справа
    translate([gear_transmission1_x, gear_transmission1_y, 1])
      cylinder(r=1+print_error, h=max_height+2, $fn=100);
    // подрезать близлежащие стойки, если есть
    translate([gear_transmission1_x, gear_transmission1_y, wheels_half_height])
      difference() {
        cylinder(r=16, h=max_height, $fn=100);
        // только не срезать текущую стойку
        cylinder(r=3.6, h=max_height);
      }

    // для шестеренок на передаче 2
    // слева
    translate([-gear_transmission2_x, gear_transmission2_y, 1])
      cylinder(r=1+print_error, h=max_height+2, $fn=100);
    // подрезать близлежащие стойки, если есть
    translate([-gear_transmission2_x, gear_transmission2_y, wheels_half_height])
      difference() {
        cylinder(r=13, h=max_height, $fn=100);
        // только не срезать текущую стойку
        cylinder(r=3.6, h=max_height);
      }
    // справа
    translate([gear_transmission2_x, gear_transmission2_y, 1])
      cylinder(r=1+print_error, h=max_height+2, $fn=100);
    // подрезать близлежащие стойки, если есть
    translate([gear_transmission2_x, gear_transmission2_y, wheels_half_height])
      difference() {
        cylinder(r=13, h=max_height, $fn=100);
        // только не срезать текущую стойку
        cylinder(r=3.6, h=max_height);
      }

    // для шестеренок на колесах 
    // слева
    translate([-gear_wheel_x, gear_wheel_y, -1])
      cylinder(r=1.5+print_error, h=max_height+2, $fn=100);
    // подрезать близлежащие стойки, если есть
    translate([-gear_wheel_x, gear_wheel_y, wheels_half_height])
      difference() {
        cylinder(r=13, h=max_height, $fn=100);
        // только не срезать текущую стойку
        cylinder(r=3.6, h=max_height);
      }
    // справа
    translate([gear_wheel_x, gear_wheel_y, -1])
      cylinder(r=1.5+print_error, h=max_height+2, $fn=100);
    // подрезать близлежащие стойки, если есть
    translate([gear_wheel_x, gear_wheel_y, wheels_half_height])
      difference() {
        cylinder(r=13, h=max_height, $fn=100);
        // только не срезать текущую стойку
        cylinder(r=3.6, h=max_height);
      }
  }
}

/**
 * Крепление мотора.
 */
module motor_fix() {
  // блок для мотора
  size_x = 24;
  size_y = 17.4;
  difference() {
    translate([-size_x/2, -size_y/2, 0]) cube([size_x, size_y, 18]);

    translate([0, 0, -1])
      linear_extrude(height=20)
        import(file="motor_face-43d.dxf");

    // пазик для контактов
    translate([-15/2, size_y/2-2, 14]) cube([15, 3, 5]);
  }
}

/**
 * Стойки для коробки и шестеренок.
 * внутреннее отверстие для винта=4мм 
 * (+зазор 1мм для погрешности печати)
 */
module box_column(height=6, r1=3.5, r2=1.5) {
  difference(){
    cylinder(h=height, r=r1, $fn=100);
    translate([0,0,-1])
      cylinder(h=height+2, r=r2, $fn=100);
  }
}
