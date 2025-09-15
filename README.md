# Teachable Dashboard (Ruby on Rails)

A minimal Ruby on Rails app that shows **published courses** from a Teachable school and, for each course, lists the **actively enrolled students** (name + email).

All data is fetched **exclusively via Teachable’s Public API** — no local database required.

## Features

* **Courses index** (published only)
* **Course show** : course name/heading and its **active** students
* Bootstrap-ready views (can be ignored / replaced)
* Production-minded requests:
  * **Timeouts + retries** (Faraday)
  * Optional **caching** (Rails cache, toggle via env)
  * Built-in **pagination** for API list endpoint

---

## Tech Stack

* Ruby 3.3.1
* Rails 7.1.5.2
* Faraday 1.10.4
* dotenv-rails 3.1.8

> No database is required to run this app.

---

## Requirements

* **Bundler 2.7.2**
* **Git**
* Teachable **API key** for a test school with data

---

## Quick Start

<pre class="overflow-visible!" data-start="1306" data-end="1604"><div class="contain-inline-size rounded-2xl relative bg-token-sidebar-surface-primary"><div class="sticky top-9"><div class="absolute end-0 bottom-0 flex h-9 items-center pe-2"><div class="bg-token-bg-elevated-secondary text-token-text-secondary flex items-center gap-4 rounded-sm px-2 font-sans text-xs"></div></div></div><div class="overflow-y-auto p-4" dir="ltr"><code class="whitespace-pre! language-bash"><span><span># 1) Clone</span><span>
git </span><span>clone</span><span> https://github.com/tabatalisboa/teachable_dashboard.git
</span><span>cd</span><span> teachable_dashboard

</span><span># 2) Install gems</span><span>
bundle install

</span><span># 3) Create .env (see below)</span><span>
</span><span>cp</span><span> .env.example .</span><span>env</span><span></span><span># or create manually</span><span>

</span><span># 4) Run the server</span><span>
bin/rails s

</span><span># 5) Open in browser</span><span>
</span><span># http://localhost:3000</span><span>
</span></span></code></div></div></pre>

---

## Configuration

Create a `.env` file in the project root:

<pre class="overflow-visible!" data-start="1672" data-end="2042"><div class="contain-inline-size rounded-2xl relative bg-token-sidebar-surface-primary"><div class="sticky top-9"><div class="absolute end-0 bottom-0 flex h-9 items-center pe-2"><div class="bg-token-bg-elevated-secondary text-token-text-secondary flex items-center gap-4 rounded-sm px-2 font-sans text-xs"></div></div></div><div class="overflow-y-auto p-4" dir="ltr"><code class="whitespace-pre! language-dotenv"><span># REQUIRED
TEACHABLE_API_KEY=your_api_key_here
TEACHABLE_API_BASE=https://developers.teachable.com
</span></code></div></div></pre>

Ensure dotenv loads in development (it’s already wired, but for reference):

<pre class="overflow-visible!" data-start="2120" data-end="2196"><div class="contain-inline-size rounded-2xl relative bg-token-sidebar-surface-primary"><div class="sticky top-9"><div class="absolute end-0 bottom-0 flex h-9 items-center pe-2"><div class="bg-token-bg-elevated-secondary text-token-text-secondary flex items-center gap-4 rounded-sm px-2 font-sans text-xs"></div></div></div><div class="overflow-y-auto p-4" dir="ltr"><code class="whitespace-pre! language-ruby"><span><span># config/application.rb</span><span>
</span><span>Dotenv</span><span>:</span><span>:Railtie</span><span>.load </span><span>if</span><span></span><span>defined</span><span>?(</span><span>Dotenv</span><span>)
</span></span></code></div></div></pre>

Enable cache in development (already set in this project):

<pre class="overflow-visible!" data-start="2257" data-end="2428"><div class="contain-inline-size rounded-2xl relative bg-token-sidebar-surface-primary"><div class="sticky top-9"><div class="absolute end-0 bottom-0 flex h-9 items-center pe-2"><div class="bg-token-bg-elevated-secondary text-token-text-secondary flex items-center gap-4 rounded-sm px-2 font-sans text-xs"></div></div></div><div class="overflow-y-auto p-4" dir="ltr"><code class="whitespace-pre! language-ruby"><span><span># config/environments/development.rb</span><span>
config.action_controller.perform_caching = </span><span>true</span><span>
config.cache_store = </span><span>:memory_store</span><span>, { </span><span>size:</span><span></span><span>64</span><span>.megabytes, </span><span>compress:</span><span></span><span>true</span><span> }
</span></span></code></div></div></pre>

---

---

## Key Endpoints (your local app)

* **Courses index:** `GET /`
* **Course details:** `GET /courses/:id`

---

## Verifying it works (UI)

Open a Rails console:

<pre class="overflow-visible!" data-start="3917" data-end="3940"><div class="contain-inline-size rounded-2xl relative bg-token-sidebar-surface-primary"><div class="sticky top-9"><div class="absolute end-0 bottom-0 flex h-9 items-center pe-2"><div class="bg-token-bg-elevated-secondary text-token-text-secondary flex items-center gap-4 rounded-sm px-2 font-sans text-xs"></div></div></div><div class="overflow-y-auto p-4" dir="ltr"><code class="whitespace-pre! language-bash"><span><span>bin/rails s</span></span></code></div></div></pre>

Open in browser
`http://localhost:3000`
