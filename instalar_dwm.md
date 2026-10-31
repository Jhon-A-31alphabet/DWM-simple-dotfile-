
# Instalacion de DWM

> **Documento histórico.** Este archivo recoge la petición original de
> instalación. La configuración actual, los scripts y el procedimiento vigente
> están en `README.md`, `INSTALL.md` y `Makefile`. Algunos valores de este
> documento (color de bordes, transparencia, sombras y orden de slstatus) ya
> cambiaron.

## ROl

**Eres un experto en Linux, saber personalizar sistemas y eres desarrollador experimentado**

---

## Tarea

 Vas a instalar en este sistema operativo ubuntu 26.04 lts el gestor de ventanas DWM desde el codigo fuente de suckless.org. Este gestor de ventanas
 sera instalado junto a las siguientes herramientas las cuales deberas instalar por las vias oficiales.:
 
    -dmenu (suckeless org)
    -slstatus (suckless org)
    -picom (apt)
    -feh (apt)
    -redshift (apt)
    -kitty (apt)
    -pamixer y pavucontrol (apt)
    -brightnessctl (apt)
    -slock (suckless org)

---

## Configuraciones
redshift,feh,picom,slstatus, deben ejecutarse en segundo plano cuando arranque DWM.

    -redshift debe ejecutarse con una temperatura de 5500k de 8 de la manana a 5 de la tarde.  En cambio de 5 de la tarde a 12 de la media noche debera ejecutarse con una temperatura de 3500k.
    - feh debera iniciar en segundo plano automaticamente inicie dwm y colocar de fondo de pantalla la siguiente imagen : /home/jhon/Imágenes/fondos/ballena_minimalista.jpeg
    -slstatus debera iniciar automaticamente con dwm y mostrar  los datos en el siguiente orde: MB RAM, %CPU, hora,fecha.
    -kitty debera iniciarse cuando yo presione las teclas ctrl + alt + z.
    -picom debera ejecutarse al instante junto con dwm es decir en segundo plano y aplicar las transparencias a las ventanas.
    -dmenu debera ejecutarse cuando presione el boton win. (el boton con el simbolo de windows).
    -pamixer y pavucontrol se deberan ejecutar solamente cuando presione los botones de volumen Fn + F2 para bajar volumen y Fn + F3 para subir volumen.
    -brightnessctl debera ejecutarse cuando presione la tecla Fn + up para subir el brillo y Fn + down para bajar el brillo.
    

##  Nota.

dmenu debera permitirme apagar el pc,reiniciar el pc y bloquear session ademas de permitirme lanzar aplicaciones.
para eso nescesito que el boton de reiniciar apagar y bloquear esten entre los 3 primeros siempre que se ejecute dmenu.

picom debera tener una transparencia del 15% de opacidad global y las sombras deben ser del color F2EB50

el color de los bordes de las ventanas en dwm debe ser : 50A1F2
y para cerrar una ventana en dwm quiero que se nescesite pulsar la siguiente combinacion : alt+f4

el teclado de este ordenador es qwerty ingles.


    
## COdigo fuente.


copia los makefiles y el codigo fuente correspondiente de dwm Y pegalos en la siguiente carpeta junto con un script de instalacion de todas las herramientas. El script de instalacion debes crearlo tu.

