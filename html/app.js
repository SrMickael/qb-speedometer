let state = {
  visible: false, // Começa oculto até receber comando para mostrar
  pos: { x: 0.82, y: 0.78 },
  scale: 1,
  unit: 'KMH',
  maxSpeed: 280
};

const root = document.getElementById('root');
const speedEl = document.getElementById('speed');
const unitEl = document.getElementById('unit');

const iconSeat = document.getElementById('icon-seatbelt');
const iconFuel = document.getElementById('icon-fuel');
const iconEngine = document.getElementById('icon-engine');

const fuelFill = document.querySelector('.fuel-fill');
const bottleNos = document.getElementById('bottle-nos');
const bottleCons2 = document.getElementById('bottle-cons2');

// Função para garantir que o HUD seja visível
function ensureVisibility() {
  if (state.visible) {
    root.classList.remove('hidden');
    root.style.display = 'block';
    root.style.visibility = 'visible';
    root.style.opacity = '1';
  } else {
    root.classList.add('hidden');
  }
}

function setSpeed(val) {
  const clamped = Math.max(0, Math.min(state.maxSpeed, val || 0));
  speedEl.innerText = String(Math.round(clamped)).padStart(3, '0');
}

function setFuel(pct, low) {
  pct = Math.max(0, Math.min(100, pct || 0));
  fuelFill.style.width = `${pct}%`;
  iconFuel.classList.toggle('low', !!low);
}

function setBottle(el, value) {
  if (value == null) {
    el.classList.add('hidden');
    return;
  }
  el.classList.remove('hidden');
  const fill = el.querySelector('.bottle-fill');
  fill.style.height = `${Math.max(0, Math.min(100, value))}%`;
}

function setSeatbelt(active) {
  iconSeat.classList.toggle('active', !!active);
}

function setEngine(bad) {
  iconEngine.classList.toggle('bad', !!bad);
}

window.addEventListener('message', (e) => {
  const d = e.data;
  switch (d.action) {
    case 'init':
      state.pos = d.pos || state.pos;
      state.scale = d.scale || 1;
      state.unit = d.unit || 'KMH';
      unitEl.textContent = (state.unit === 'MPH') ? 'MPH' : 'KM/H';
      // Não mostrar automaticamente na inicialização
      break;
      
    case 'setVisible':
      state.visible = !!d.show;
      ensureVisibility();
      break;
      
    case 'setConsumable2':
      setBottle(bottleCons2, d.value);
      break;
      
    case 'update':
      if (state.visible) {
        setSpeed(d.spd || 0);
        setFuel(d.fuel || 0, d.fuelLow);
        setSeatbelt(d.seatbelt);
        setEngine(d.engineBad);
        setBottle(bottleNos, d.nitro);
      }
      break;
  }
});

// Inicializar como oculto
ensureVisibility();

