'use strict';

const { modules, lessons, glossary, labs } = window.ATLAS;
const main = document.querySelector('#main');
const nav = document.querySelector('#navigation');
const progressBox = document.querySelector('#sidebar-progress');
const storageKey = 'atlas-neural.progress.v1';
const icons = {
  home:'<path d="m3 11 9-7 9 7v9H3z"/><path d="M9 20v-6h6v6"/>',
  book:'<path d="M12 6c-3-2-6-2-9-1v14c3-1 6-1 9 1 3-2 6-2 9-1V5c-3-1-6-1-9 1v14"/>',
  flask:'<path d="M9 3h6m-5 0v7L4 19a1 1 0 0 0 1 2h14a1 1 0 0 0 1-2l-6-9V3M7 15h10"/>',
  glossary:'<rect x="4" y="3" width="16" height="18" rx="2"/><path d="m8 15 3-7 3 7m-5-2h4m3 2h2"/>',
  trend:'<path d="M3 4v16h18M6 15l4-4 4 2 5-7"/>',
  network:'<path d="m7 6 10 2m-10-2 1 12m9-10-9 10m9-10 1 10M8 18h10"/><circle cx="7" cy="6" r="2"/><circle cx="17" cy="8" r="2"/><circle cx="8" cy="18" r="2"/><circle cx="18" cy="18" r="2"/>',
  layers:'<path d="m3 8 9-5 9 5-9 5zM3 12l9 5 9-5M3 16l9 5 9-5"/>',
  spark:'<path d="M12 2l2.5 6.5L21 11l-6.5 2.5L12 20l-2.5-6.5L3 11l6.5-2.5zM19 16v6m-3-3h6"/>',
  team:'<path d="M3 20v-2c0-2 2-3 5-3s5 1 5 3v2m3-5c3 0 5 1 5 3v2"/><circle cx="8" cy="8" r="3"/><path d="M16 5a3 3 0 0 1 0 6"/>',
  bookmark:'<path d="M6 4h12v17l-6-4-6 4z"/>',
  check:'<path d="m5 12 4 4L19 6"/>',
  play:'<path d="m8 5 12 7-12 7z"/>',
  search:'<circle cx="10.5" cy="10.5" r="5.5"/><path d="m15 15 5 5"/>',
  clock:'<circle cx="12" cy="12" r="9"/><path d="M12 7v6l3 2"/>',
  screen:'<rect x="3" y="4" width="18" height="13" rx="2"/><path d="M9 21h6m-3-4v4"/>',
};
const moduleIcons = {ml:'trend', neural:'network', deep:'layers', llm:'spark', agents:'team'};
const colors = {ml:['#e2efd8','#365c39'], neural:['#e0ece4','#356252'], deep:['#f4ebce','#715522'], llm:['#e5e7f4','#4d5887'], agents:['#f4e4db','#874b37']};
const pages = [['inicio','Início','home'],['trilha','Trilha','book'],['laboratorio','Laboratório','flask'],['glossario','Glossário','glossary']];
const findLesson = id => lessons.find(lesson => lesson.id === id);
const findModule = id => modules.find(module => module.id === id);
const icon = name => `<svg class="icon" viewBox="0 0 24 24" aria-hidden="true">${icons[name] ?? icons.spark}</svg>`;
const tile = name => `<span class="tile">${icon(name)}</span>`;
const theme = id => `style="--tint:${colors[id][0]};--accent:${colors[id][1]}"`;
const normalize = text => text.normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase();
const plural = (n, one, many) => `${n} ${n === 1 ? one : many}`;
const fmt = (n, decimals = 2) => n.toLocaleString('pt-BR', {minimumFractionDigits:decimals, maximumFractionDigits:decimals});
const button = (label, action, css = '', value = '') => `<button type="button" class="btn ${css}" data-do="${action}" data-value="${value}">${label}</button>`;
const link = (label, href, css = '') => `<a class="btn ${css}" href="#${href}">${label}</a>`;
const heading = (title, description, label, symbol) => `<header class="page-head"><div class="eyebrow">${icon(symbol)} ${label}</div><h1>${title}</h1><p>${description}</p></header>`;
let savedState;
try { savedState = JSON.parse(localStorage.getItem(storageKey)); } catch { savedState = null; }
let completed = new Set(Array.isArray(savedState?.completed) ? savedState.completed.filter(findLesson) : []);
let saved = new Set(Array.isArray(savedState?.saved) ? savedState.saved.filter(findLesson) : []);
let lastLesson = findLesson(savedState?.lastLesson)?.id;
let previousPage = 'inicio';
let lessonBack = 'trilha';
let labBack = 'laboratorio';
let route = [];
let quizChoice = null;
let slide = 0;
let revealed = false;
let labState;
let chartObserver;
let storedSearch = '';

function saveProgress() {
  try { localStorage.setItem(storageKey, JSON.stringify({completed:[...completed], saved:[...saved], lastLesson})); } catch {}
  updateNav();
}

function updateNav() {
  const active = {licao:'trilha', apresentar:'trilha', simulacao:'laboratorio'}[route[0]] ?? route[0];
  nav.innerHTML = pages.map(([id,title,symbol]) => `<a class="nav-item" href="#${id}" ${active === id ? 'aria-current="page"' : ''}>${icon(symbol)}${title}</a>`).join('');
  progressBox.innerHTML = `<div class="progress-box"><div>${icon('trend')} Seu progresso</div><div class="progress-track" role="progressbar" aria-label="Lições concluídas" aria-valuenow="${completed.size}" aria-valuemax="${lessons.length}"><div class="progress-fill" style="width:${completed.size / lessons.length * 100}%"></div></div><p>${completed.size} de ${lessons.length} lições concluídas</p></div>`;
}

function moduleCard(module) {
  const count = lessons.filter(lesson => lesson.module === module.id).length;
  return `<a class="module-card" href="#trilha/${module.id}" ${theme(module.id)}>${tile(moduleIcons[module.id])}<div><h3>${module.title}</h3><p>${module.subtitle}</p></div><span class="card-meta">${plural(count,'lição','lições')}</span></a>`;
}
function labCard(lab) {
  return `<a class="lab-card" href="#simulacao/${lab.id}" ${theme(lab.module)}>${tile(moduleIcons[lab.module])}<div><h3>${lab.title}</h3><p>${lab.summary}</p></div><span class="card-meta">${findModule(lab.module).title}</span></a>`;
}
function home() {
  const next = (lastLesson && !completed.has(lastLesson) && findLesson(lastLesson)) || lessons.find(lesson => !completed.has(lesson.id));
  return `<section class="hero"><canvas id="atlas-graphic" aria-hidden="true"></canvas><div class="hero-content"><div class="eyebrow">${icon('network')} Atlas Neural</div><h1>Explore a inteligência <em>artificial.</em></h1><p>Do primeiro modelo aos sistemas multiagentes. Aprenda em português com lições, perguntas de revisão e simulações interativas.</p><div class="actions">${link(next ? icon('play') + (completed.size || lastLesson ? 'Continuar estudo' : 'Começar a trilha') : 'Rever a trilha', next ? 'licao/' + next.id : 'trilha','primary')}${link(icon('flask')+'Abrir laboratório','laboratorio','secondary')}</div></div></section>
  <div class="metrics" aria-label="Conteúdo do Atlas Neural">${[[modules.length,'Módulos','layers'],[lessons.length,'Lições','book'],[labs.length,'Simulações','flask']].map(([n,label,symbol])=>`<div class="metric">${tile(symbol)}<div><strong>${n}</strong><small>${label}</small></div></div>`).join('')}</div>
  <section><div class="section-head"><div><h2>Trilha de aprendizado</h2><p>Escolha um módulo para estudar.</p></div><a class="text-link" href="#trilha">Ver trilha completa</a></div><div class="module-grid">${modules.map(moduleCard).join('')}</div></section>
  <section class="home-labs"><div class="section-head"><div><h2>Laboratório</h2><p>Mude os parâmetros e observe o que acontece.</p></div><a class="text-link" href="#laboratorio">Ver simulações</a></div><div class="lab-grid">${labs.slice(0,3).map(labCard).join('')}</div></section>`;
}
function bookmark(lesson) {
  const active = saved.has(lesson.id);
  return `<button type="button" class="icon-btn" data-do="save" data-value="${lesson.id}" aria-pressed="${active}" aria-label="${active ? 'Remover de salvas' : 'Salvar lição'}: ${lesson.title}" title="${active ? 'Remover de salvas' : 'Salvar lição'}">${icon('bookmark')}</button>`;
}
function trail() {
  const selection = route[1] === 'salvas' || findModule(route[1]) ? route[1] : 'todas';
  const options = [['todas','Todas'],['salvas','Salvas'],...modules.map(module=>[module.id,module.title])];
  const groups = modules.filter(module=>['todas','salvas',module.id].includes(selection)).map(module=>{
    const rows = lessons.filter(lesson => lesson.module === module.id && (selection !== 'salvas' || saved.has(lesson.id)));
    if (!rows.length) return '';
    return `<section class="trail-group" ${theme(module.id)}><div class="group-head">${tile(moduleIcons[module.id])}<div><h2>${module.title}</h2><p>${module.subtitle}</p></div></div>${rows.map(lesson=>`<div class="lesson-row"><a href="#licao/${lesson.id}"><h3>${lesson.title}</h3><p>${lesson.summary}</p></a><span class="meta">${lesson.minutes} min</span>${completed.has(lesson.id) ? `<span class="status-icon" role="img" aria-label="Concluída">${icon('check')}</span>` : ''}${bookmark(lesson)}</div>`).join('')}</section>`;
  }).join('');
  return heading('Trilha',`Estude os conceitos na ordem dos módulos ou abra uma lição salva. ${completed.size} de ${lessons.length} lições concluídas.`,'Aprendizado','book')+`<div class="filters" aria-label="Filtrar lições">${options.map(([id,name])=>`<a class="filter" href="#trilha/${id}" ${id===selection?'aria-current="true"':''}>${name}</a>`).join('')}</div>`+(groups||'<div class="empty">Nenhuma lição neste filtro.</div>');
}
function glossaryPage() {
  return heading('Glossário','Busque por um termo ou por uma palavra na definição.','Conceitos','glossary')+'<label class="search">'+icon('search')+'<input id="search" type="search" placeholder="Buscar no glossário" aria-label="Buscar no glossário" autocomplete="off"></label><p class="result-count" id="result-count" role="status"></p><div id="terms" class="term-grid"></div>';
}
function populateTerms(query) {
  const filter = normalize(query.trim());
  const filtered = glossary.filter(item=>normalize(item.term+' '+item.definition).includes(filter)).sort((a,b)=>a.term.localeCompare(b.term,'pt-BR'));
  document.querySelector('#result-count').textContent = plural(filtered.length,'termo','termos');
  document.querySelector('#terms').innerHTML = filtered.length ? filtered.map(item=>`<a class="term" href="#licao/${item.lesson}"><h3>${item.term}</h3><p>${item.definition}</p></a>`).join('') : '<div class="empty">Nenhum termo encontrado.</div>';
}
function lessonPage(lesson) {
  const module = findModule(lesson.module);
  const next = lessons[lessons.indexOf(lesson)+1];
  return `<article class="reading"><a class="text-link back" href="#${lessonBack}">Voltar</a><header class="lesson-header"><div class="eyebrow">${icon(moduleIcons[module.id])}${module.title} · ${lesson.minutes} min</div><h1>${lesson.title}</h1><p>${lesson.summary}</p><div class="actions">${link(icon('screen')+'Apresentar lição','apresentar/'+lesson.id,'primary')}${bookmark(lesson)}${lesson.lab?link(icon('flask')+'Abrir simulação','simulacao/'+lesson.lab):''}</div></header>
  ${lesson.sections.map(section=>`<section class="content-card"><h2>${section.title}</h2><p>${section.text}</p></section>`).join('')}
  <section class="content-card note"><h2>Na prática</h2><p>${lesson.example}</p></section>
  <section class="content-card"><h2>Para explicar</h2><p>${lesson.explain}</p></section>
  <section class="content-card" id="quiz"><h2>Revise o que aprendeu</h2><p class="question">${lesson.quiz.prompt}</p><div class="options">${lesson.quiz.options.map((option,i)=>`<button class="option" type="button" data-do="quiz" data-value="${i}" aria-pressed="${quizChoice===i}">${option}</button>`).join('')}</div><p id="quiz-feedback" aria-live="polite" ${quizChoice===null?'hidden':''}></p></section>
  <div class="actions">${button(completed.has(lesson.id)?icon('check')+'Lição concluída':'Marcar como concluída','complete','primary',lesson.id)}${next?link('Próxima lição','licao/'+next.id):link('Voltar à trilha','trilha')}</div></article>`;
}
function refreshQuiz(lesson) {
  const feedback = document.querySelector('#quiz-feedback');
  if (quizChoice === null) return;
  main.querySelectorAll('[data-do="quiz"]').forEach((node,index)=>node.setAttribute('aria-pressed',String(index===quizChoice)));
  const correct = quizChoice === lesson.quiz.answer;
  feedback.hidden = false;
  feedback.className = 'feedback'+(correct?' correct':'');
  feedback.textContent = correct ? 'Correto. '+lesson.quiz.feedback : 'Tente outra resposta. Releia a lição se precisar.';
}
function presentationSlides(lesson) {
  return [{label:findModule(lesson.module).title,title:lesson.title,text:lesson.summary},
    ...lesson.sections.map(section=>({label:'Conceito',...section})),
    {label:'Exemplo',title:'Na prática',text:lesson.example},
    {label:'Para explicar',title:'Em sala de aula',text:lesson.explain},
    {label:'Revisão',title:lesson.quiz.prompt,quiz:lesson.quiz}];
}
function presentation(lesson) {
  const slides = presentationSlides(lesson);
  const item = slides[slide];
  return `<a class="text-link back" href="#licao/${lesson.id}">Sair da apresentação</a><section class="slide-frame" aria-label="Slide ${slide+1} de ${slides.length}"><div class="eyebrow">${item.label}</div><h1>${item.title}</h1>${item.text?`<p>${item.text}</p>`:''}${item.quiz?`<ol type="A">${item.quiz.options.map(option=>`<li>${option}</li>`).join('')}</ol>${revealed?`<p><strong>${item.quiz.options[item.quiz.answer]}</strong><br>${item.quiz.feedback}</p>`:`<div class="actions">${button('Revelar resposta','reveal')}</div>`}`:''}</section><div class="slide-controls"><button type="button" class="btn" data-do="prev" ${slide===0?'disabled':''}>Anterior</button><span aria-live="polite">Slide ${slide+1} de ${slides.length}</span><button type="button" class="btn primary" data-do="next" ${slide===slides.length-1?'disabled':''}>Próximo</button></div>`;
}

const points = [[-2,-1.8],[-1.2,-.9],[-.5,.2],[.4,.75],[1.1,2.1],[1.7,2.6],[2.2,3.35]];
const initRegression = () => ({slope:.15,intercept:0});
const initNeuron = () => ({a:1.2,b:-.5,bias:-.3});
const stageTitles = ['Definir o objetivo','Consultar o catálogo','Analisar a resposta','Pedir aprovação','Reserva simulada','Execução encerrada'];
const stageDetails = [
  'Encontrar um livro introdutório sobre IA com retirada nesta semana.',
  'O agente envia assunto e prazo à ferramenta de busca.',
  'A busca retorna dois livros. Apenas IA para curiosos tem um exemplar disponível no prazo.',
  'O agente apresenta o livro e o prazo e aguarda a decisão antes de alterar a disponibilidade.',
  'A ferramenta simulada registra a reserva de IA para curiosos até sexta-feira.',
  'O agente encerra a tarefa e mantém a disponibilidade no catálogo.'
];
const slider = (key,label,value,min,max,step) => `<label class="slider"><span>${label}<output id="value-${key}">${fmt(value)}</output></span><input id="${key}" data-param="${key}" type="range" min="${min}" max="${max}" step="${step}" value="${value}"></label>`;
const readout = (caption,value,id='') => `<div class="readout"><small>${caption}</small><strong ${id?'id="'+id+'"':''}>${value}</strong></div>`;
const segment = (label,action,value,active) => `<button type="button" class="filter" data-do="${action}" data-value="${value}" aria-pressed="${active}" ${active?'aria-current="true"':''}>${label}</button>`;
function labIndex() {
  return heading('Laboratório','Experimente cinco simulações com dados didáticos, dos modelos lineares à coordenação de agentes.','Simulações','flask')+`<div class="lab-grid">${labs.map(labCard).join('')}</div>`;
}
function labPage(lab) {
  return `<article class="lab-body"><a class="text-link back" href="#${labBack}">Voltar</a>${heading(lab.title,lab.summary,findModule(lab.module).title,moduleIcons[lab.module])}<div id="lab-interior">${labInterior(lab.id)}</div></article>`;
}
function labInterior(id) {
  if (id === 'regression') {
    return `<div class="content-card"><canvas id="regression-plot" aria-label="Gráfico de dispersão com pontos observados e a reta prevista" role="img"></canvas><div class="lab-output" aria-live="polite">${readout('Erro quadrático médio','','loss')}</div>${slider('slope','Inclinação',labState.slope,-2,2,.001)}${slider('intercept','Intercepto',labState.intercept,-2,2,.001)}<div class="actions">${button('Dar um passo','step','primary')}${button('Reiniciar','reset')}</div></div><div class="content-card note"><p>A perda é a média dos quadrados das diferenças entre as previsões e os pontos observados. A descida do gradiente ajusta a reta para reduzir essa perda.</p></div>`;
  }
  if (id === 'neuron') {
    return `<div class="content-card"><h2>Ativação sigmoide</h2><p>σ(0,8 × w₁ + 0,4 × w₂ + b)</p>${slider('a','Peso da entrada 1',labState.a,-3,3,.01)}${slider('b','Peso da entrada 2',labState.b,-3,3,.01)}${slider('bias','Viés',labState.bias,-3,3,.01)}<div class="lab-output" aria-live="polite">${readout('Soma ponderada','','sum')}${readout('Ativação','','activation')}</div><div class="actions">${button('Reiniciar','reset')}</div></div><div class="content-card note"><p>A sigmoide transforma a soma em um valor entre zero e um. Uma soma igual a zero produz 0,5.</p></div>`;
  }
  if (id === 'attention') {
    const garden = labState === 'garden';
    const scores = garden ? [2.3,1.5,-.7,-.4] : [-.7,-.5,2.5,1.6];
    const exp = scores.map(score=>Math.exp(score-Math.max(...scores)));
    const total = exp.reduce((sum,n)=>sum+n,0);
    const rows = ['praça','árvore','crédito','conta'].map((name,i)=>`<div class="attention-row"><strong>${name}</strong><div class="bar" style="--value:${100*exp[i]/total}%" aria-hidden="true"></div><span>${fmt(100*exp[i]/total,1)}%</span></div>`).join('');
    return `<div class="content-card"><div class="filters">${segment('Praça','context','garden',garden)}${segment('Finanças','context','finance',!garden)}</div><p>A consulta de «banco» aparece ${garden?'no contexto de uma praça':'em um contexto financeiro'}.</p>${rows}</div><div class="content-card note"><p>O softmax converte as pontuações ilustrativas em pesos que somam 100% antes do arredondamento.</p></div>`;
  }
  if (id === 'agent') {
    const current = labState;
    const trace = [0,1,2,3].filter(i=>i<=current).concat(current>=4?[current]:[]);
    const actions = current<3 ? button(stageTitles[current+1],'agent-next','primary') : current===3 ? button('Aprovar reserva','approval','primary','4')+button('Recusar','approval','','5') : '';
    return `<div class="content-card"><h2>Histórico da execução</h2><ol class="agent-flow">${trace.map(i=>`<li ${i===current?'aria-current="step"':''}>${stageTitles[i]}</li>`).join('')}</ol><div aria-live="polite"><h3>${stageTitles[current]}</h3><p>${stageDetails[current]}</p></div><div class="actions">${actions}${current>0?button('Reiniciar simulação','reset'):''}</div></div><div class="content-card note"><p>O catálogo é fictício. Compare o resultado depois de aprovar ou recusar a reserva.</p></div>`;
  }
  const parallel = labState === 'parallel';
  const tasks = [['Checar fontes',0,3],['Revisar clareza',parallel?0:3,2],['Consolidar',parallel?3:5,1]];
  return `<div class="content-card"><div class="filters">${segment('Em série','team','serial',!parallel)}${segment('Em paralelo','team','parallel',parallel)}</div>${tasks.map(([name,start,duration])=>`<div class="timeline-row"><p><strong>${name}</strong> · ${start}–${start+duration} min</p><div class="timeline" aria-hidden="true"><span style="width:${duration/6*100}%;margin-left:${start/6*100}%"></span></div></div>`).join('')}<div class="lab-output" aria-live="polite">${readout('Duração total',(parallel?4:6)+' min')}</div></div><div class="content-card note"><p>Etapas independentes podem avançar juntas. A consolidação começa quando as duas revisões terminam.</p></div>`;
}
function defaultLab(id) {
  switch (id) {
    case 'regression': return initRegression();
    case 'neuron': return initNeuron();
    case 'attention': return 'garden';
    case 'agent': return 0;
    case 'team': return 'serial';
  }
}
function regressionNumbers() {
  const {slope,intercept}=labState;
  return points.reduce((sum,[x,y])=>sum+(slope*x+intercept-y)**2,0)/points.length;
}
function syncLab(id) {
  if (id==='regression') {
    document.querySelector('#loss').textContent = fmt(regressionNumbers(),3);
    paintRegression();
  }
  if (id==='neuron') {
    const sum=.8*labState.a+.4*labState.b+labState.bias;
    document.querySelector('#sum').textContent = fmt(sum);
    document.querySelector('#activation').textContent = fmt(1/(1+Math.exp(-sum)),3);
  }
}
function redrawLab(focusAction) {
  const id=route[1];
  document.querySelector('#lab-interior').innerHTML=labInterior(id);
  observeChart();
  syncLab(id);
  const candidate = main.querySelector('[data-do="'+focusAction+'"][aria-pressed="true"]') || main.querySelector('[data-do="'+focusAction+'"]') || main.querySelector('#lab-interior button');
  candidate?.focus({preventScroll:true});
}
function fitCanvas(canvas) {
  if (!canvas) return null;
  const {width,height}=canvas.getBoundingClientRect();
  if (!width || !height) return null;
  const scale=Math.min(window.devicePixelRatio||1,2);
  canvas.width=Math.round(width*scale);
  canvas.height=Math.round(height*scale);
  const ctx=canvas.getContext('2d');
  if (!ctx) return null;
  ctx.scale(scale,scale);
  return {ctx,width,height};
}
function paintRegression() {
  const surface=fitCanvas(document.querySelector('#regression-plot'));
  if (!surface) return;
  const {ctx,width,height}=surface;
  const inset={left:34,right:14,top:11,bottom:30};
  const w=width-inset.left-inset.right;
  const h=height-inset.top-inset.bottom;
  const values=points.map(([x,y])=>y);
  const {slope,intercept}=labState;
  const predicted=[-2.5,2.5].map(x=>slope*x+intercept);
  const bounds=[...values,...predicted];
  const ymin=Math.floor(Math.min(-3,...bounds));
  const ymax=Math.ceil(Math.max(4,...bounds));
  const px=x=>inset.left+(x+2.5)/5*w;
  const py=y=>inset.top+(ymax-y)/(ymax-ymin)*h;
  const draw=(x1,y1,x2,y2,stroke,linewidth)=>{ctx.strokeStyle=stroke;ctx.lineWidth=linewidth;ctx.beginPath();ctx.moveTo(x1,y1);ctx.lineTo(x2,y2);ctx.stroke();};
  ctx.font='12px system-ui';
  ctx.fillStyle='#53635a';
  for(let y=ymin;y<=ymax;y++) {
    draw(inset.left,py(y),width-inset.right,py(y),y===0?'#859a85':'#dce5d7',1);
    ctx.fillText(String(y),6,py(y)+4);
  }
  for(let x=-2;x<=2;x++) {
    draw(px(x),inset.top,px(x),height-inset.bottom,x===0?'#859a85':'#dce5d7',1);
    ctx.fillText(String(x),px(x)-5,height-8);
  }
  draw(px(-2.5),py(predicted[0]),px(2.5),py(predicted[1]),'#9a583c',2.6);
  for(const [x,y] of points) {
    ctx.fillStyle='#2d6848';ctx.beginPath();ctx.arc(px(x),py(y),4.5,0,Math.PI*2);ctx.fill();
  }
}
function paintHero() {
  const canvas=document.querySelector('#atlas-graphic');
  if (!canvas) return;
  const surface=fitCanvas(canvas);
  if (!surface) return;
  const {ctx,width,height}=surface;
  const radius=Math.min(width*.40,height*.39);
  const cx=width*.52,cy=height*.51;
  const mesh=[];
  const count=85;
  for(let i=0;i<count;i++) {
    const y=1-2*(i+.5)/count;
    const r=Math.sqrt(1-y*y);
    const theta=i*Math.PI*(3-Math.sqrt(5));
    const x=r*Math.cos(theta),z=r*Math.sin(theta);
    mesh.push({x:x*.84+z*.54,y:y*.94-z*.29,z:x*.48-y*.28-z*.72});
  }
  const screen=p=>[cx+p.x*radius,cy+p.y*radius];
  ctx.strokeStyle='#c1e98620';
  for(let ring=1;ring<=3;ring++) {
    ctx.beginPath();ctx.arc(cx,cy,radius*(1.04+ring*.085),0,Math.PI*2);ctx.stroke();
  }
  for(let i=0;i<mesh.length;i++) for(let j=i+1;j<mesh.length;j++) {
    const a=mesh[i],b=mesh[j];
    const dist=Math.hypot(a.x-b.x,a.y-b.y,a.z-b.z);
    if(dist>.44) continue;
    const [ax,ay]=screen(a),[bx,by]=screen(b);
    ctx.strokeStyle=(a.z+b.z)/2>0?'#c8f78475':'#97d49d30';
    ctx.beginPath();ctx.moveTo(ax,ay);ctx.lineTo(bx,by);ctx.stroke();
  }
  for(const [i,p] of mesh.entries()) {
    const [x,y]=screen(p);
    const bright=i%13===0;
    ctx.fillStyle=bright?'#e3ff9f':p.z>0?'#a9e88cbb':'#9acfa173';
    if(bright){ctx.shadowColor='#d3ff89';ctx.shadowBlur=14;}
    ctx.beginPath();ctx.arc(x,y,bright?3.7:p.z>0?1.7:1.1,0,Math.PI*2);ctx.fill();ctx.shadowBlur=0;
  }
}

function observeChart() {
  chartObserver?.disconnect();
  const target = main.querySelector('canvas');
  if (!target) return;
  const paint = target.id==='atlas-graphic'?paintHero:paintRegression;
  paint();
  if (typeof ResizeObserver !== 'undefined') {
    chartObserver=new ResizeObserver(paint);
    chartObserver.observe(target);
  }
}
function render() {
  const [page,id] = route;
  const lesson = findLesson(id);
  let title = pages.find(entry=>entry[0]===page)?.[1];
  let view;
  switch (page) {
    case 'trilha': view=trail(); break;
    case 'laboratorio': view=labIndex(); break;
    case 'glossario': view=glossaryPage(); break;
    case 'licao': title=lesson.title;view=lessonPage(lesson);break;
    case 'apresentar': title=lesson.title;view=presentation(lesson);break;
    case 'simulacao': {
      const lab=labs.find(item=>item.id===id);
      title=lab.title;
      view=labPage(lab);
      break;
    }
    default: view=home();
  }
  main.innerHTML=`<div class="wrap">${view}</div>`;
  document.title=page==='inicio'?'Atlas Neural':title+' · Atlas Neural';
  updateNav();
  if(page==='glossario') {
    document.querySelector('#search').value=storedSearch;
    populateTerms(storedSearch);
  }
  if(page==='licao') refreshQuiz(lesson);
  observeChart();
  if(page==='simulacao') syncLab(id);
}
function navigate(focus = false) {
  const hash = location.hash.slice(1);
  if(hash==='main') { main.focus(); return; }
  const [page,id] = (hash||'inicio').split('/');
  const validPage=pages.some(entry=>entry[0]===page)
    || (['licao','apresentar'].includes(page)&&findLesson(id))
    || (page==='simulacao'&&labs.some(lab=>lab.id===id));
  const lastRoute=route;
  route=validPage?[page,id]:['inicio'];
  const newPage=route[0];
  if(newPage==='licao') {
    if(lastRoute.length && ['inicio','trilha','glossario'].includes(previousPage)) lessonBack=lastRoute.filter(Boolean).join('/');
    lastLesson=id;
    quizChoice=null;
    saveProgress();
  }
  if(newPage==='apresentar') {slide=0;revealed=false;}
  if(newPage==='simulacao') {
    labBack=previousPage==='licao'?'licao/'+lastRoute[1]:'laboratorio';
    labState=defaultLab(id);
  }
  previousPage=newPage;
  render();
  window.scrollTo(0,0);
  if(focus) main.focus({preventScroll:true});
}
function goSlide(delta) {
  const next=slide+delta;
  if(next<0||next>=presentationSlides(findLesson(route[1])).length) return;
  slide=next;
  revealed=false;
  render();
  (main.querySelector('[data-do="'+(delta>0?'next':'prev')+'"]:not([disabled])') || main.querySelector('.slide-controls button:not([disabled])'))?.focus({preventScroll:true});
}
main.addEventListener('click',event=>{
  const target=event.target.closest('[data-do]');
  if(!target) return;
  const {do:action,value}=target.dataset;
  const id=route[1];
  switch(action) {
    case 'save':
      if(saved.has(value)) saved.delete(value); else saved.add(value);
      saveProgress();
      if(route[0]==='trilha'&&id==='salvas') { render(); (main.querySelector('[data-do="save"]')||main).focus({preventScroll:true}); }
      else { target.outerHTML=bookmark(findLesson(value)); main.querySelector('[data-do="save"][data-value="'+value+'"]').focus({preventScroll:true}); }
      break;
    case 'complete':
      if(completed.has(value)) completed.delete(value); else completed.add(value);
      saveProgress();
      target.innerHTML=completed.has(value)?icon('check')+'Lição concluída':'Marcar como concluída';
      break;
    case 'quiz': quizChoice=Number(value);refreshQuiz(findLesson(id));break;
    case 'prev': goSlide(-1);break;
    case 'next': goSlide(1);break;
    case 'reveal': revealed=true;render();main.querySelector('.slide-frame').setAttribute('tabindex','-1');main.querySelector('.slide-frame').focus({preventScroll:true});break;
    case 'reset': labState=defaultLab(id);redrawLab(action);break;
    case 'step': {
      let ds=0,di=0;
      for(const [x,y] of points) { const residual=labState.slope*x+labState.intercept-y;ds+=residual*x;di+=residual; }
      const clamp=n=>Math.min(2,Math.max(-2,n));
      labState.slope=clamp(labState.slope-.32*ds/points.length);
      labState.intercept=clamp(labState.intercept-.32*di/points.length);
      for(const key of ['slope','intercept']) {
        document.getElementById(key).value=labState[key];
        document.getElementById('value-'+key).textContent=fmt(labState[key]);
      }
      syncLab(id);
      break;
    }
    case 'context':
    case 'team': labState=value;redrawLab(action);break;
    case 'agent-next': labState++;redrawLab(action);break;
    case 'approval': labState=Number(value);redrawLab('reset');break;
  }
});
main.addEventListener('input',event=>{
  const input=event.target;
  if(input.id==='search') {
    storedSearch=input.value;
    populateTerms(storedSearch);
  }
  if(input.dataset.param) {
    const key=input.dataset.param;
    labState[key]=Number(input.value);
    document.getElementById('value-'+key).textContent=fmt(labState[key]);
    syncLab(route[1]);
  }
});
window.addEventListener('keydown',event=>{
  if(route[0]!=='apresentar'||event.altKey||event.ctrlKey||event.metaKey) return;
  if(event.key==='ArrowLeft'||event.key==='ArrowRight') {
    event.preventDefault();
    goSlide(event.key==='ArrowLeft'?-1:1);
  }
  if(event.key==='Escape') location.hash='licao/'+route[1];
});
window.addEventListener('hashchange',()=>navigate(true));
navigate();
