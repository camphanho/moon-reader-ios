import { useEffect, useState } from 'react';
import { useReaderStore } from '../store/readerStore';

export function useReadingProgress() {
  const currentPage = useReaderStore((state) => state.currentPage);
  const pagination = useReaderStore((state) => state.pagination);
  const setPage = useReaderStore((state) => state.setPage);

  const [progress, setProgress] = useState(0);

  useEffect(() => {
    if (!pagination?.totalPages) return;
    setProgress(Math.round(((currentPage + 1) / pagination.totalPages) * 100));
  }, [currentPage, pagination]);

  const goToNextPage = () => {
    if (!pagination) return;
    if (currentPage < pagination.totalPages - 1) {
      setPage(currentPage + 1);
    }
  };

  const goToPreviousPage = () => {
    if (currentPage > 0) {
      setPage(currentPage - 1);
    }
  };

  return {
    currentPage,
    totalPages: pagination?.totalPages || 0,
    progress,
    goToNextPage,
    goToPreviousPage,
    setPage,
  };
}

