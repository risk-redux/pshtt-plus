# pshtt-plus

`pshtt-plus` began as a custom tool (based primarily on the CISA open source tool, `pshtt`) to help with analysis of my agency's public-facing footprint, but can scale out to support the entire .gov domain space.

## Queuing

A major driver for this project was the need to be able to produce fresh report data for a lot of domains/websites on an ad hoc basis. Scalability of the "scans" is important and the tasks involved are inherently parralelizable. This required selection of a queuing service (Redis) and a platform for "workers" (Sidekiq). Luckily Rails and Heroku both provide the scaffolding to make using both pretty easy.

## Scheduled tasks

I'm using Heroku's native scheduler to occassionally (and arbitrarily) queue up lots of jobs and generate reports on the data those jobs collect.

## Data visualization pipeline

Making the visualizations work is a bit convoluted. I had initially wanted to just import the D3 libraries and write some scripts I could serve directly in various views; however, D3 is now Observables, and that complicates things a bit. Roughly speaking, to make this work, I:

- Need to account for cross-origin resource sharing and provide a `Access-Control-Allow-Origin: https://egyptiankarim.static.observableusercontent.com` response header, so that the Observable visualizations can load data from the web application's API endpoints.
- Have to ensure that the API enpoints provide consumable JSON objects that can drive the visualizations.
- Always publish updates to the API to production prior to tweaking the visualizations, because CORS policies only allow single origin directives or wide open wildcards (unless I want to code up an even more conoluted middleware filtering scheme).
- Settle for not being able to test in the development environment, as I can run Observables locally and I can't serve up data from anywhere but production.
