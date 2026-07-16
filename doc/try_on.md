<!DOCTYPE html><html class="light" lang="en"><head>
<meta charset="utf-8">
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<title>Virtual Try-On | Onboarding</title>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@500;600&amp;family=Plus+Jakarta+Sans:wght@400;500;600&amp;family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@100..900&amp;family=Plus+Jakarta+Sans:wght@100..900&amp;display=swap" rel="stylesheet">
<style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        .glass-effect {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
        }
        .ar-scanner-line {
            height: 2px;
            background: linear-gradient(90deg, transparent, #805443, transparent);
            width: 100%;
            position: absolute;
            top: 0;
            animation: scan 3s ease-in-out infinite;
        }
        @keyframes scan {
            0% { top: 10%; opacity: 0; }
            50% { opacity: 1; }
            100% { top: 90%; opacity: 0; }
        }
        .floating-product {
            animation: float 4s ease-in-out infinite;
        }
        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
        }
    </style>
<script id="tailwind-config">tailwind.config = {darkMode: "class", theme: {extend: {colors: {"on-error": "#ffffff", "on-surface-variant": "#4e4540", "tertiary-fixed": "#f2dfd6", "on-error-container": "#93000a", "inverse-surface": "#313030", "surface-container-high": "#eae7e7", "primary-fixed-dim": "#d7c2b9", secondary: "#805443", "surface-container-lowest": "#ffffff", "on-primary-fixed": "#241913", "on-tertiary-fixed": "#231914", "on-surface": "#1c1b1b", "on-background": "#1c1b1b", "error-container": "#ffdad6", primary: "#6b5b53", "primary-fixed": "#f4ded4", "outline-variant": "#d2c4be", "on-tertiary-fixed-variant": "#51443e", "on-tertiary-container": "#72635c", "inverse-primary": "#d7c2b9", "on-secondary-fixed-variant": "#653d2d", "primary-container": "#f7e1d7", "surface-container-highest": "#e5e2e1", "on-secondary-container": "#7a4f3e", tertiary: "#695c55", background: "#fcf9f8", "surface-container": "#f0eded", "secondary-fixed": "#ffdbce", surface: "#fcf9f8", "on-secondary-fixed": "#311306", "surface-dim": "#dcd9d9", "on-primary": "#ffffff", "on-tertiary": "#ffffff", error: "#ba1a1a", "on-primary-fixed-variant": "#52443d", "inverse-on-surface": "#f3f0ef", "surface-container-low": "#f6f3f2", "secondary-fixed-dim": "#f3baa4", "surface-variant": "#e5e2e1", "on-secondary": "#ffffff", "secondary-container": "#ffc5af", "surface-tint": "#6b5b53", "tertiary-container": "#f5e2d9", outline: "#807570", "on-primary-container": "#73635b", "tertiary-fixed-dim": "#d5c3ba", "surface-bright": "#fcf9f8"}, borderRadius: {DEFAULT: "0.25rem", lg: "0.5rem", xl: "0.75rem", full: "9999px"}, spacing: {md: "24px", base: "8px", "margin-desktop": "64px", sm: "12px", "container-max": "1200px", xl: "64px", lg: "40px", "margin-mobile": "20px", xs: "4px", gutter: "20px"}, fontFamily: {"body-lg": ["Plus Jakarta Sans"], caption: ["Plus Jakarta Sans"], "headline-lg-mobile": ["Playfair Display"], "headline-md": ["Playfair Display"], "headline-lg": ["Playfair Display"], "label-md": ["Plus Jakarta Sans"], "display-lg": ["Playfair Display"], "body-md": ["Plus Jakarta Sans"], headline: ["Playfair Display"], display: ["Playfair Display"], body: ["Plus Jakarta Sans"], label: ["Plus Jakarta Sans"]}, fontSize: {"body-lg": ["18px", {lineHeight: "28px", fontWeight: "400"}], caption: ["12px", {lineHeight: "16px", fontWeight: "400"}], "headline-lg-mobile": ["28px", {lineHeight: "34px", fontWeight: "600"}], "headline-md": ["24px", {lineHeight: "32px", fontWeight: "500"}], "headline-lg": ["32px", {lineHeight: "40px", fontWeight: "600"}], "label-md": ["14px", {lineHeight: "20px", letterSpacing: "0.05em", fontWeight: "600"}], "display-lg": ["48px", {lineHeight: "56px", letterSpacing: "-0.02em", fontWeight: "600"}], "body-md": ["16px", {lineHeight: "24px", fontWeight: "400"}]}}}};</script>
<style>
    body {
      min-height: max(884px, 100dvh);
    }
  </style>
<style>
    body {
      min-height: max(884px, 100dvh);
    }
  </style>
<style>
    body {
      min-height: max(884px, 100dvh);
    }
  </style>
  </head>
<body class="bg-background text-on-background font-body-md overflow-x-hidden">
<!-- Top AppBar - Following JSON Structure -->
<header class="fixed top-0 left-0 w-full z-50 flex justify-between items-center w-full px-margin-mobile py-base max-w-container-max mx-auto bg-transparent">
<button class="flex items-center justify-center w-10 h-10 text-primary dark:text-primary-fixed-dim hover:opacity-80 transition-opacity active:scale-95 duration-200 ease-in-out">
<span class="material-symbols-outlined" data-icon="arrow_back">arrow_back</span>
</button>
<button class="text-label-md font-label-md text-primary dark:text-primary-fixed-dim hover:opacity-80 transition-opacity active:scale-95 duration-200 ease-in-out">
            Skip
        </button>
</header>
<main class="min-h-screen flex flex-col items-center justify-between pt-xl pb-32">
<!-- Hero Section: AR Try-on Experience -->
<div class="relative w-full max-w-container-max flex flex-col md:flex-row items-center gap-lg px-margin-mobile flex-grow">
<!-- Left: Text Content (Editorial Layout) -->
<div class="w-full md:w-5/12 flex flex-col justify-center order-2 md:order-1 text-center md:text-left">
<span class="text-label-md font-label-md text-secondary mb-base">AUGMENTED REALITY</span>
<h1 class="text-headline-lg-mobile md:text-headline-lg font-headline-lg-mobile md:font-headline-lg mb-md">
                    Virtual Try-On
                </h1>
<p class="text-body-lg font-body-lg text-on-surface-variant max-w-md mx-auto md:mx-0">
                    Experiment with thousands of shades and products instantly from home.
                </p>
<!-- Product Preview Chips -->
<div class="mt-lg w-full bg-surface-container-low p-base rounded-xl border border-outline-variant/30 shadow-sm">
    <div class="grid grid-cols-1 gap-md">
        <!-- Lipstick Shades -->
        <div>
            <h3 class="text-label-md font-label-md text-on-surface mb-sm text-center md:text-left">Lipstick Shades (Matte, Satin)</h3>
            <div class="grid grid-cols-3 gap-sm justify-items-center md:justify-items-start">
                <div class="w-10 h-10 rounded-full bg-[#B03060] border-2 border-white shadow-sm cursor-pointer hover:scale-110 transition-transform"></div>
                <div class="w-10 h-10 rounded-full bg-[#DC143C] border-2 border-white shadow-sm cursor-pointer hover:scale-110 transition-transform"></div>
                <div class="w-10 h-10 rounded-full bg-[#C71585] border-2 border-white shadow-sm cursor-pointer hover:scale-110 transition-transform"></div>
                <div class="w-10 h-10 rounded-full bg-[#800020] border-2 border-white shadow-sm cursor-pointer hover:scale-110 transition-transform"></div>
                <div class="w-10 h-10 rounded-full bg-[#DB7093] border-2 border-white shadow-sm cursor-pointer hover:scale-110 transition-transform"></div>
                <div class="w-10 h-10 rounded-full bg-[#FF69B4] border-2 border-white shadow-sm cursor-pointer hover:scale-110 transition-transform"></div>
            </div>
        </div>
        
        <div class="flex gap-md">
            <!-- Foundation Finder -->
            <div class="flex-1">
                <h3 class="text-label-md font-label-md text-on-surface mb-sm text-center md:text-left">Foundation Finder</h3>
                <div class="flex flex-col gap-xs">
                    <div class="h-6 w-full rounded bg-[#F5D0B9] border border-outline-variant/20 shadow-sm"></div>
                    <div class="h-6 w-full rounded bg-[#E8B899] border border-outline-variant/20 shadow-sm"></div>
                    <div class="h-6 w-full rounded bg-[#D4A373] border border-outline-variant/20 shadow-sm"></div>
                    <div class="h-6 w-full rounded bg-[#A67C52] border border-outline-variant/20 shadow-sm"></div>
                    <div class="h-6 w-full rounded bg-[#704214] border border-outline-variant/20 shadow-sm"></div>
                </div>
            </div>

            <!-- Eyeliner Styles -->
            <div class="flex-1">
                <h3 class="text-label-md font-label-md text-on-surface mb-sm text-center md:text-left">Eyeliner Styles</h3>
                <div class="flex flex-col gap-sm items-center md:items-start">
                    <div class="flex items-center gap-xs text-caption font-caption text-on-surface-variant">
                        <span class="material-symbols-outlined text-secondary">visibility</span> Wing
                    </div>
                    <div class="flex items-center gap-xs text-caption font-caption text-on-surface-variant">
                        <span class="material-symbols-outlined text-secondary">remove_red_eye</span> Cat Eye
                    </div>
                    <div class="flex items-center gap-xs text-caption font-caption text-on-surface-variant">
                        <span class="material-symbols-outlined text-secondary">eye_tracking</span> Natural
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</div>
<!-- Right: AR Visualization (Bento-inspired Image) -->
<div class="w-full md:w-7/12 order-1 md:order-2 flex justify-center relative">
<div class="relative w-full aspect-[4/5] md:aspect-square max-w-[500px]">
<!-- Main AR View -->
<div class="absolute inset-0 rounded-xl overflow-hidden shadow-xl Level-2">
<div class="w-full h-full bg-cover bg-center" data-alt="A professional close-up shot of a sophisticated woman looking into a high-tech smart mirror. Subtle digital AR overlays show vibrant rose-gold lipstick and soft charcoal eyeshadow perfectly mapped to her facial features. The lighting is soft and flattering, emphasizing a clean skincare aesthetic. The surrounding environment is a minimalist, luxury vanity room with soft-focus marble and gold accents, conveying a premium digital sanctuary feel." style="background-image: url(&quot;https://lh3.googleusercontent.com/aida-public/AB6AXuDKXpwXmac8JpVttl5BxxNG2lx08WEjevFymdkEgpiUShEX4IEy1uTzr7AtGEWqKSClgp5oaXYyxuwadFiEI57DRf1BzqrnKLEKEdVoOPb2Rhe5XuN1PGPKoIDF1YTyB5Bbaz4FjvttkNViOHPVNGiqQEWXJaPTcBh_JouKYgbvbU0x-nC5JMY6MPtWOD3T9vd3aemQUBSX_Po1-IUGNgoozvKPb8Wo00wSLL4ets5UYopj6WniHEwLR1m7qKhmt_vRinhRf1rGgSId&quot;);">
<!-- Scanning Overlay -->
<div class="ar-scanner-line"></div>
<!-- AR Face Trackers -->
<div class="absolute top-1/4 left-1/4 w-12 h-12 border-t-2 border-l-2 border-secondary/50 rounded-tl-lg"></div>
<div class="absolute top-1/4 right-1/4 w-12 h-12 border-t-2 border-r-2 border-secondary/50 rounded-tr-lg"></div>
<div class="absolute bottom-1/4 left-1/4 w-12 h-12 border-b-2 border-l-2 border-secondary/50 rounded-bl-lg"></div>
<div class="absolute bottom-1/4 right-1/4 w-12 h-12 border-b-2 border-r-2 border-secondary/50 rounded-br-lg"></div>
</div>
</div>
<!-- Floating Interaction Cards -->
<div class="absolute -bottom-6 -left-6 glass-effect p-base rounded-xl shadow-lg border border-outline-variant/30 flex items-center gap-base floating-product" style="animation-delay: 0.5s;">
<div class="w-12 h-12 rounded-lg bg-cover bg-center" data-alt="Close-up of a premium lipstick tube in a minimalist white and gold case, sitting on a clean, reflective surface. The product is surrounded by a soft warm glow, part of a high-end beauty product line." style="background-image: url('https://lh3.googleusercontent.com/aida-public/AB6AXuDNNCLth0z4vLcp5pmECYCim0iDnT8nhBuBmRJU75w98NKACRgcJSh4ltpPzApjBh3dcYN3Q_qOsDj75nWK86W9BF6LXrBT6drnLz4TUWuIcthNtmqxRfsH6GuF1zCGq8LWY-7FpClDzUe2jT9zNtlkoK535bqCN3BOQsNeUFxgAHYGFj0TtYrahw0Ak4mtPHweff0vARDL14Ym1dw515x-SIm_kP5oFWoJrWGYfoe83mC-4bBjCJLXpyHpXMq9ZbvJbrnJWlziFg')"></div>
<div>
<div class="text-label-md font-label-md">Radiant Matte</div>
<div class="text-caption font-caption text-secondary">Applying...</div>
</div>
</div>
<div class="absolute top-10 -right-4 glass-effect p-sm rounded-full shadow-lg border border-outline-variant/30 flex items-center justify-center floating-product">
<span class="material-symbols-outlined text-secondary" style="font-variation-settings: 'FILL' 1;">auto_fix_high</span>
</div>
</div>
</div>
</div>
<!-- Footer Actions -->
<div class="w-full max-w-container-max px-margin-mobile flex flex-col items-center gap-lg mt-xl">
<button class="w-full md:w-auto px-xl py-md bg-secondary text-on-secondary rounded-xl text-label-md font-label-md hover:opacity-90 transition-all active:scale-95 shadow-md">
                Next
            </button>
</div>
</main>
<!-- Bottom Navigation Shell (Dots only for onboarding) -->
<nav class="fixed bottom-lg left-0 w-full z-50 flex justify-center items-center h-md bg-transparent">
<div class="flex items-center">
<!-- Inactive Dot 1 -->
<div class="w-2 h-2 bg-outline-variant dark:bg-on-surface-variant rounded-full mx-1 transition-all duration-300"></div>
<!-- Active Dot 2 -->
<div class="w-3 h-3 bg-secondary dark:bg-secondary-fixed rounded-full mx-1 transition-all duration-300"></div>
<!-- Inactive Dot 3 -->
<div class="w-2 h-2 bg-outline-variant dark:bg-on-surface-variant rounded-full mx-1 transition-all duration-300"></div>
</div>
</nav>
<!-- Subtle Background Elements -->
<div class="fixed top-0 right-0 -z-10 w-1/3 h-1/2 opacity-20 pointer-events-none">
</div>
<script>
        // Micro-interaction: button scale
        document.querySelectorAll('button').forEach(btn => {
            btn.addEventListener('touchstart', () => btn.classList.add('scale-95'));
            btn.addEventListener('touchend', () => btn.classList.remove('scale-95'));
        });
    </script>




</body></html>