# Frontend Error Patterns

## Global error handlers

Safety net for unhandled errors. Register at application entry point.

```javascript
window.addEventListener('unhandledrejection', (event) => {
  console.error('Unhandled rejection:', event.reason);
  errorReporter?.captureException(event.reason);
  showToast('An unexpected error occurred', 'error');
  event.preventDefault();
});

window.addEventListener('error', (event) => {
  console.error('Global error:', event.error);
  errorReporter?.captureException(event.error);
});
```

`event.preventDefault()` in `unhandledrejection` suppresses the default console error — use only when you
handle the error yourself.

## Error boundaries — React

Use `react-error-boundary` over hand-rolled class components.

```jsx
import { ErrorBoundary, useErrorBoundary } from 'react-error-boundary';

function ErrorFallback({ error, resetErrorBoundary }) {
  return (
    <div role="alert">
      <p>Something went wrong: {error.message}</p>
      <button onClick={resetErrorBoundary}>Try again</button>
    </div>
  );
}

// Wrap component tree — scope boundaries to recoverable sections
<ErrorBoundary
  FallbackComponent={ErrorFallback}
  onReset={() => queryClient.clear()}
  resetKeys={[userId]}
>
  <UserProfile />
</ErrorBoundary>
```

For async errors (not caught by boundaries natively), use `showBoundary`:

```jsx
function UserData({ id }) {
  const { showBoundary } = useErrorBoundary();

  useEffect(() => {
    fetchUser(id).catch(showBoundary);
  }, [id]);
}
```

## Error boundaries — Vue

```javascript
// Global handler
app.config.errorHandler = (error, instance, info) => {
  console.error('Vue error:', error, info);
  errorReporter?.captureException(error);
};

// Component-level — onErrorCaptured lifecycle hook
onErrorCaptured((error, instance, info) => {
  // return false to stop propagation
  return false;
});
```

## Error boundaries — Svelte 5

```svelte
<svelte:boundary onerror={(error, reset) => handleError(error)}>
  <RiskyComponent />

  {#snippet failed(error, reset)}
    <p>Error: {error.message}</p>
    <button onclick={reset}>Retry</button>
  {/snippet}
</svelte:boundary>
```

## React Query / TanStack Query error handling

Three strategies that work best combined:

```javascript
// 1. throwOnError — propagate to error boundary (filter by status)
useQuery({
  queryKey: ['user', id],
  queryFn: fetchUser,
  throwOnError: (error) => error.status >= 500, // only server errors
});

// 2. Global callbacks on QueryCache — toast for background refetch failures
const queryClient = new QueryClient({
  queryCache: new QueryCache({
    onError: (error, query) => {
      if (query.state.data !== undefined) {
        toast.error(`Background update failed: ${error.message}`);
      }
    },
  }),
});

// 3. Per-query isError — local handling for expected failures
const { data, isError, error } = useQuery({ queryKey: ['user', id], queryFn: fetchUser });
if (isError) return <InlineError message={error.message} />;
```

Background refetch failures: show toast, preserve stale data.
Initial load failures: propagate to error boundary.

## Graceful degradation with fallback

```javascript
async function fetchWithFallback(url, cacheKey) {
  try {
    return await fetch(url).then((r) => r.json());
  } catch (error) {
    console.warn('Fetch failed, using cache:', error);
    const cached = getCached(cacheKey);
    return cached ? { ...cached, stale: true } : null;
  }
}
```

## Fetch error classification

`fetch()` only rejects on network errors. HTTP 4xx/5xx are successful responses — check `response.ok`.

```javascript
const request = async (url, options) => {
  const response = await fetch(url, options);
  if (!response.ok) {
    const body = await response.json().catch(() => null);
    throw new APIError(body?.message ?? response.statusText, response.status);
  }
  return response.json();
};
```

## Sources

- [Error Handling — Frontend Patterns](https://frontendpatterns.dev/error-handling/) — global handlers, centralized handler, graceful degradation
- [Use react-error-boundary to handle errors in React — Kent C. Dodds](https://kentcdodds.com/blog/use-react-error-boundary-to-handle-errors-in-react) — ErrorBoundary API, resetKeys, useErrorBoundary
- [React Query Error Handling — TkDodo](https://tkdodo.eu/blog/react-query-error-handling) — throwOnError, global QueryCache callbacks, combining strategies
- [Svelte docs — svelte:boundary](https://svelte.dev/docs/svelte/svelte-boundary) — Svelte 5 error boundaries
- [Vue docs — Error Handling](https://vuejs.org/api/application.html#app-config-errorhandler) — app.config.errorHandler, onErrorCaptured
- [MDN — Window: error event](https://developer.mozilla.org/en-US/docs/Web/API/Window/error_event)
- [MDN — Window: unhandledrejection event](https://developer.mozilla.org/en-US/docs/Web/API/Window/unhandledrejection_event)
